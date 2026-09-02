# Deploy Ember Ascent to Cloudflare

The repository contains Godot source. Cloudflare cannot deploy `.gd` / `.tscn` files directly as a website. The Web preset exports the playable site to `build/web/index.html`.

## 1. Export the Web build

In Godot 4.3:

1. Open the project.
2. Project > Export.
3. Select `Web`.
4. Export Project.
5. Keep the output path as `build/web/index.html`.

Or from a machine with Godot 4.3 and export templates installed:

```sh
godot --headless --path . --export-release "Web" build/web/index.html
```

Verify that `build/web/` contains `index.html` plus the generated JavaScript/WASM/PCK files.

## 2A. Cloudflare Workers static assets

The repository includes `wrangler.toml` with:

```toml
[assets]
directory = "./build/web"
```

Deploy with:

```sh
npm install
npm run deploy
```

If using Cloudflare Workers Builds connected to GitHub, the deploy command can remain:

```sh
npx wrangler deploy
```

But the build step must create `build/web` before the deploy step. Cloudflare does not include Godot by default, so either commit the exported `build/web` files or use CI that installs Godot and export templates.

## 2B. Cloudflare Pages

For Pages, use:

```sh
npx wrangler pages deploy build/web --project-name=ember-ascent
```

For Git-integrated Pages with committed Web output:

- Framework preset: None
- Build command: `exit 0`
- Build output directory: `build/web`
- Production branch: `main`

## HTML standalone build

If deploying the standalone HTML version instead of the Godot Web export, create a folder such as `public/`, rename the final standalone game HTML to `public/index.html`, then use:

```sh
npx wrangler pages deploy public --project-name=ember-ascent
```

The apex URL requires an `index.html` in the deployed static directory.
