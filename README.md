# A Tinderbox Installer Template

A forkable template for building GitHub-backed [Tinderbox](https://www.eastgate.com/Tinderbox/) installers. Fork this repo, rename it, customize `install.tbxc`, and you have a one-line installer for your own Tinderbox prototypes, templates, and tools.

## Quick Start

1. **Fork** this repo and rename it (e.g., `tbx-myproject`)
2. **Edit** `install.tbxc` to install your own prototypes, templates, stamps, etc.
3. **Run** `bash setup.sh` to configure the dev environment
4. **Test** locally, then push — URLs are automatically switched for distribution

## How It Works

The installer pattern uses a `loc` variable in `install.tbxc` that points to a GitHub raw URL. The installer fetches components via `curl` at install time. Users install by either:

- **Downloading the .tbx file** — open it in Tinderbox and paste the note into their document (`$OnPaste` runs the installer automatically)
- **Using a stamp** — create a stamp with: `action(runCommand("curl -s https://raw.githubusercontent.com/jacobio/tbx-installer/main/install.tbxc"));`

## Developer Tooling

### Smudge/Clean Filter (automatic)

The `local-url` filter automatically switches URLs so you can develop locally while git stays clean:

- **Working tree**: local `file:` protocol URLs (for testing)
- **Committed content**: `https://raw.githubusercontent.com/.../` (remote URLs for distribution)

This is configured by `setup.sh` and handled by `scripts/url-filter.sh`.

### Manual Mode Switch

Use `scripts/set-mode.sh` to manually switch between local and remote URLs:

```bash
scripts/set-mode.sh local    # Switch to local URLs
scripts/set-mode.sh remote   # Switch to remote GitHub URLs
```

### Pre-push Hook

The `.githooks/pre-push` hook blocks pushes if local URLs are found in committed content — a safety net in case the filter isn't configured.

## Customizing

### Adding Components

Edit `install.tbxc` to add your own Tinderbox components. Common patterns:

```
// Create a prototype
var:string note = create("/Prototypes/MyPrototype");
$IsPrototype(note) = true;
$Badge(note) = "⭐";

// Fetch text content from a file in your repo
$Text(note) = runCommand("curl -s " + loc + "content/my-file.md").trim;

// Create a template
note = create("/Templates/MyTemplate");
$IsTemplate(note) = true;
$Text(note) = runCommand("curl -s " + loc + "templates/my-template.html").trim;
```

### Adding Fetched Files

Put any files your installer needs (templates, CSS, highlighters, etc.) in the repo. Reference them from `install.tbxc` using the `loc` variable:

```
runCommand("curl -s " + loc + "path/to/file.ext")
```

### Filtering Additional Files

If you add files that contain URLs (beyond `install.tbxc` and `README.md`), add them to `.gitattributes`:

```
my-new-file.tbxc filter=local-url
```

## Examples

Real-world installers built with this pattern:

- [tbx-markdown](https://github.com/jacobio/tbx-markdown) — Enhanced Markdown prototype with syntax highlighting, preview, and HTML export
- [tbx-notetaker](https://github.com/jacobio/tbx-notetaker) — Note-taking stamps and prototypes (in progress)
- [tbx-pandoc](https://github.com/jacobio/tbx-pandoc) — Pandoc export integration (in progress)

## Repo Structure

```
tbx-installer/
├── install.tbxc              # Main installer (fetched by the one-liner)
├── install-tbx-installer.tbx # Tinderbox file with installer stamp
├── tbx-readme.md             # In-document README (installed into Tinderbox)
├── scripts/
│   ├── url-filter.sh         # Smudge/clean filter for URL switching
│   └── set-mode.sh           # Manual local/remote URL switcher
├── .githooks/
│   └── pre-push              # Blocks push if local URLs in commits
├── .gitattributes            # Filter configuration
├── setup.sh                  # One-command dev environment setup
└── LICENSE
```

## License

MIT
