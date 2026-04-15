import os
import json
import sublime
import sublime_plugin
from types import SimpleNamespace

repositories_cache = None

def expand_path(path: str, relative_to: str):
    if path[0] == "~":
        return os.path.expanduser(path)
    elif path[0] == "/":
        return path
    else:
        return os.path.join(relative_to, path)

def load_settings():
    settings = sublime.load_settings("ProjectManager.sublime-settings")

    project_roots = []
    for project_root in settings.get("project_roots", []):
        raw_path = project_root.get("path")
        path = os.path.expanduser(raw_path)

        project_roots.append(SimpleNamespace(
            prefix = project_root.get("prefix", ""),
            raw_path = raw_path,
            path = path,
            ignored_projects = project_root.get("ignored_projects", []),
            output_dir = expand_path(project_root.get("output_dir", ".sublime"), path),
        ))

    additional_projects = []
    for project in settings.get("additional_projects", []):
        raw_path = project.get("path")
        path = os.path.expanduser(raw_path)

        additional_projects.append(SimpleNamespace(
            name = project.get("name") or os.path.basename(path),
            raw_path = raw_path,
            path = path,
        ))

    return SimpleNamespace(
        project_roots = project_roots,
        additional_projects = additional_projects,
        delete_stale = settings.get("delete_stale", True),
    )

def find_repositories(settings):
    repositories = []

    # git projects
    for project_root in settings.project_roots:
        try:
            for filename in os.listdir(project_root.path):
                if filename in project_root.ignored_projects:
                    continue

                path = os.path.join(project_root.path, filename)

                if os.path.isdir(os.path.join(path, ".git")):
                    name = project_root.prefix + filename

                    repositories.append(SimpleNamespace(
                        name = name,
                        path = path,
                        raw_path = os.path.join(project_root.raw_path, filename),
                        project_file = os.path.join(
                            project_root.output_dir,
                            f"{name}.sublime-project"
                        ),
                    ))

        except Exception as e:
            print(f"[ProjectManager] Error listing projects in {project_root.raw_path}: {e}")

    # additional projects
    for proj in settings.additional_projects:
        repositories.append(SimpleNamespace(
            name = proj.name,
            path = proj.path,
            raw_path = proj.raw_path,
            project_file = os.path.join(
                proj.path,
                f"{proj.name}.sublime-project",
            ),
        ))

    # sort alphabetically
    return sorted(
        repositories,
        key = lambda repo: repo.name.lower()
    )

def find_project_files(project_output_dir):
    return {
        # project name -> project file paths
        filename.replace(".sublime-project", ""): os.path.join(project_output_dir, filename)
        for filename in os.listdir(project_output_dir)
        if filename.endswith(".sublime-project")
    }

def create_repo_link(repo):
    command_url = sublime.command_url("open_dir", {"dir": repo.path})
    return f'<a href="{command_url}">{repo.raw_path}</a>'

def refresh_projects():
    settings = load_settings()

    # # Debug
    # print(f'[ProjectManager] settings = {settings}')

    # make output directories
    for root in settings.project_roots:
        os.makedirs(root.output_dir, exist_ok = True)

    # find repositories
    repositories = find_repositories(settings)

    # cache repositories
    global repositories_cache
    repositories_cache = repositories

    # create missing projects
    created = []
    for repository in repositories:
        if not os.path.exists(repository.project_file):
            try:
                with open(repository.project_file, "w") as f:
                    json.dump({
                        "folders": [{"path": repository.raw_path}]
                    }, f, indent = 4)

                created.append(repository.name)
            except Exception as e:
                print(f"[ProjectManager] Error creating project {repository.name}: {e}")

    # remove stale projects
    removed = []
    if settings.delete_stale:
        # all project files across all roots
        expected_project_files = list(map(lambda repo: repo.project_file, repositories))

        for root in settings.project_roots:
            existing_projects = find_project_files(root.output_dir)

            for name, project_file in existing_projects.items():
                # only if project file isn't from a repo
                if project_file not in expected_project_files:
                    # delete project file
                    try:
                        os.remove(project_file)
                        removed.append(name)
                    except Exception as e:
                        print(f"[ProjectManager] Error removing project {name}: {e}")

                    # delete workspace file
                    try:
                        workspace_file = os.path.join(
                            root.output_dir, f"{name}.sublime-workspace"
                        )
                        if os.path.exists(workspace_file):
                            os.remove(workspace_file)
                    except Exception as e:
                        print(f"[ProjectManager] Error removing workspace {name}: {e}")

    # log overview
    if len(created) > 0 or len(removed) > 0:
        print(f"[ProjectManager] Created: {created}, Removed: {removed}")

    sublime.status_message("Project refresh complete!")

class ProjectManagerOpenCommand(sublime_plugin.WindowCommand):
    def run(self):
        # load settings
        settings = load_settings()

        # find repositories
        global repositories_cache
        repositories = repositories_cache or find_repositories(settings)
        if len(repositories) < 1:
            sublime.message_dialog("No projects found. Run refresh first.")
            return

        # cache repositories
        # NOTE: will likely already be set by on_init, but not guaranteed
        repositories_cache = repositories

        # TODO: consider listening for changes in all roots (and their children) instead of refreshing here
        # trigger refresh in the background
        sublime.set_timeout_async(refresh_projects, 0)

        # create a panel item for each repository
        panel_items = [
            sublime.QuickPanelItem(repo.name, create_repo_link(repo))
            for repo in repositories
        ]

        # show switcher
        def on_select(index):
            if index == -1:
                return

            repo = repositories[index]

            # close current project first
            if self.window.project_file_name():
                self.window.run_command("close_workspace")

            # switch to project
            sublime.run_command("open_project_or_workspace", {
                "file": repo.project_file
            })

        self.window.show_quick_panel(panel_items, on_select)

class ProjectManagerRefreshCommand(sublime_plugin.WindowCommand):
    def run(self):
        # print("[ProjectManager] refresh command")
        # trigger refresh in the background
        sublime.set_timeout_async(refresh_projects, 0)

class ProjectManagerListener(sublime_plugin.EventListener):
    def on_init(self, _views):
        # print("[ProjectManager] on_init")
        # trigger refresh in the background
        sublime.set_timeout_async(refresh_projects, 0)
