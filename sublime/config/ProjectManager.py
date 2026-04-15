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

    return SimpleNamespace(
        project_roots = project_roots,
        delete_stale = settings.get("delete_stale", True),
    )

def find_repositories(project_roots):
    all_repositories = {}

    for project_root in project_roots:
        root_repositories = {}

        try:
            for filename in os.listdir(project_root.path):
                if filename in project_root.ignored_projects:
                    continue

                path = os.path.join(project_root.path, filename)

                if os.path.isdir(os.path.join(path, ".git")):
                    name = project_root.prefix + filename
                    raw_path = os.path.join(project_root.raw_path, filename)

                    root_repositories[name] = SimpleNamespace(
                        path = path,
                        raw_path = raw_path,
                        root = project_root,
                    )

        except Exception as e:
            print(f"[ProjectManager] Error listing projects in {project_root.raw_path}: {e}")

        all_repositories[project_root.path] = (project_root, root_repositories)

    return all_repositories

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

    # Debug
    print(f'[ProjectManager] settings = {settings}')

    # make output directories
    for root in settings.project_roots:
        os.makedirs(root.output_dir, exist_ok=True)

    # find repositories
    repositories_by_root = find_repositories(settings.project_roots)

    # cache repositories
    global repositories_cache
    repositories_cache = repositories_by_root

    # refresh all roots
    created = []
    removed = []
    for _, (project_root, repositories) in repositories_by_root.items():
        # find project files
        existing_projects = find_project_files(project_root.output_dir)

        # create missing projects
        for name, repo in repositories.items():
            # create project file
            if name not in existing_projects:
                project_file = os.path.join(project_root.output_dir, f"{name}.sublime-project")
                with open(project_file, "w") as f:
                    json.dump({
                        "folders": [{"path": repo.raw_path}]
                    }, f, indent=4)

                created.append(name)

        # remove stale projects
        if settings.delete_stale:
            for name, project_file in existing_projects.items():
                if name not in repositories:
                    # delete project file
                    try:
                        os.remove(project_file)

                        removed.append(name)
                    except Exception as e:
                        print(f"[ProjectManager] Error removing project {name}: {e}")

                    # delete workspace file
                    try:
                        workspace_file = os.path.join(
                            project_root.output_dir, f"{name}.sublime-workspace"
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

        # find project files
        global repositories_cache
        repositories_by_root = repositories_cache or find_repositories(settings.project_roots)

        # cache repositories
        # NOTE: likely already be set by on_init, but maybe we can be run first?
        repositories_cache = repositories_by_root

        # TODO: consider listening for changes in all roots (and their children) instead of refreshing here
        # trigger refresh in the background
        sublime.set_timeout_async(refresh_projects, 0)

        # flatten repos
        repo_entries = [
            (name, repo)
            for (_, repos) in repositories_by_root.values()
            for name, repo in repos.items()
        ]

        if len(repo_entries) < 1:
            sublime.message_dialog("No projects found. Run refresh first.")
            return

        # sort repos alphabetically
        repo_entries.sort()

        # create a panel item for each repository
        panel_items = [
            sublime.QuickPanelItem(name, create_repo_link(repo))
            for name, repo in repo_entries
        ]

        # show switcher
        def on_select(index):
            if index == -1:
                return

            name, repo = repo_entries[index]
            project_file = os.path.join(repo.root.output_dir, f"{name}.sublime-project")

            # close current project first
            if self.window.project_file_name():
                self.window.run_command("close_workspace")

            # switch to project
            sublime.run_command("open_project_or_workspace", {
                "file": project_file
            })

        self.window.show_quick_panel(panel_items, on_select)

class ProjectManagerRefreshCommand(sublime_plugin.WindowCommand):
    def run(self):
        print("[ProjectManager] refresh command")
        # trigger refresh in the background
        sublime.set_timeout_async(refresh_projects, 0)

class ProjectManagerListener(sublime_plugin.EventListener):
    def on_init(self, _views):
        print("[ProjectManager] on_init")
        # trigger refresh in the background
        sublime.set_timeout_async(refresh_projects, 0)
