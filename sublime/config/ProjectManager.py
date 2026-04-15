import os
import json
import sublime
import sublime_plugin
from types import SimpleNamespace

repositories_cache = None

def load_settings():
    settings = sublime.load_settings("ProjectManager.sublime-settings")

    project_roots = []
    for project_root in settings.get("project_roots", []):
        raw_path = project_root.get("path")
        project_roots.append(SimpleNamespace(
            prefix = project_root.get("prefix", ""),
            raw_path = raw_path,
            path = os.path.expanduser(raw_path),
            ignored_projects = project_root.get("ignored_projects", []),
        ))

    # TODO: maybe this should just be relative to the project root? (this way we don't even need to check for roots in delete_stale)
    project_output_dir = os.path.expanduser(
        settings.get("project_output_dir", "~/Projects/.sublime")
    )

    return SimpleNamespace(
        project_roots = project_roots,
        project_output_dir = project_output_dir,
        delete_stale = settings.get("delete_stale", True),
    )

def find_repositories(project_roots):
    repositories = {}

    for project_root in project_roots:
        # TODO: handle directories not existing
        for filename in os.listdir(project_root.path):
            # skip ignored projects
            if filename in project_root.ignored_projects:
                continue

            # check if file is a git repo
            path = os.path.join(project_root.path, filename)
            if os.path.isdir(os.path.join(path, ".git")):
                name = project_root.prefix + filename
                raw_path = project_root.raw_path + '/' + filename
                repositories[name] = SimpleNamespace(
                    path = path,
                    raw_path = raw_path,
                )

    return repositories

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
    os.makedirs(settings.project_output_dir, exist_ok=True)

    # find repositories
    repositories = find_repositories(settings.project_roots)

    # cache repositories
    global repositories_cache
    repositories_cache = repositories

    # find project files
    existing_projects = find_project_files(settings.project_output_dir)

    # create missing projects
    created = []
    for name, repo in repositories.items():
        # create project file
        # TODO: check existing_projects instead?
        project_file = os.path.join(settings.project_output_dir, f"{name}.sublime-project")
        if not os.path.exists(project_file):
            with open(project_file, "w") as f:
                json.dump({
                    "folders": [{"path": repo.raw_path}]
                }, f, indent=4)

            created.append(name)

    # remove stale projects
    # NOTE: we skip this if there are no project roots configured,
    # this is likely a misconfiguration
    removed = []
    if settings.delete_stale and len(settings.project_roots) > 0:
        for name, project_file in existing_projects.items():
            if name not in repositories:
                try:
                    # delete project file
                    os.remove(project_file)

                    # delete workspace file
                    workspace_file = os.path.join(
                        settings.project_output_dir, f"{name}.sublime-workspace"
                    )
                    if os.path.exists(workspace_file):
                        os.remove(workspace_file)

                    removed.append(name)
                except Exception as e:
                    print(f"[ProjectManager] Error removing {name}: {e}")

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
        repositories = repositories_cache or find_repositories(settings.project_roots)
        if len(repositories) < 1:
            sublime.message_dialog("No projects found. Run refresh first.")
            return

        # cache repositories
        # NOTE: likely already be set by on_init, but maybe we can be run first?
        repositories_cache = repositories

        # trigger refresh in the background
        sublime.set_timeout_async(refresh_projects, 0)

        # create a panel item for each repository
        repo_entries = list(repositories.items())
        panel_items = [
            sublime.QuickPanelItem(name, create_repo_link(repo))
            for name, repo in repo_entries
        ]

        # show switcher
        def on_select(index):
            if index == -1:
                return

            name, _ = repo_entries[index]
            project_file = os.path.join(settings.project_output_dir, f"{name}.sublime-project")

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
        refresh_projects()

class ProjectManagerListener(sublime_plugin.EventListener):
    def on_init(self, _views):
        print("[ProjectManager] on_init")
        refresh_projects()
