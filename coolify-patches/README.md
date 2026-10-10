# Palawan Collective ??? Coolify branding & behavior patches

Private PaaS instance: **https://studio.merqato.digital** (UpCloud VPS, Singapore).

This branch keeps every customization made on top of stock Coolify so they can
be re-applied in minutes after a Coolify self-update. **Updates recreate the
container and wipe anything customized inside it** ??? this already happened on
2026-10-09 (4.4.2 ??? 4.4.6).

Built against Coolify v4.4.2; file structure re-validated against v4.4.6.

## What is customized

1. **Branding** ??? every capital-"Coolify" in the Blade views becomes
   "Palawan Collective"; browser title tail becomes "Studio"
   (`[Palawan Collective] Dashboard | Studio`). Lowercase `coolify`
   identifiers (paths, container names) are intentionally untouched.
2. **Login screen** ??? the turtle logo sits above the sign-in card
   (`components/auth/shell.blade.php`, applied to all auth pages).
3. **Assets** (in the container's `public/`) ??? `favicon.ico` (16,776 b,
   multi-size), `apple-touch-icon.png` (8,434 b), `coolify-logo.svg`
   (white turtle, 36 KB), `login-logo.png` (233 KB turtle + wordmark).
4. **Popups killed** ??? the real-time-service warning, the sponsorship ask and
   the "no notifications enabled" nag are hard-disabled in
   `livewire/layout-popups.blade.php` (per-browser localStorage flags proved
   unreliable ??? they reset per browser/profile).
5. **Instance identity** ??? `APP_NAME='Palawan Collective'` in
   `/data/coolify/source/.env` (**must stay QUOTED** ??? an unquoted space
   crashes the app with "The environment file is invalid!"), plus instance
   name + URL set in the UI.

## Re-apply after every Coolify update

Run from this folder on your machine (docker + ssh to the VPS):

```sh
# 1 - assets into the container
docker cp assets/favicon.ico        coolify:/var/www/html/public/favicon.ico
docker cp assets/apple-touch-icon.png coolify:/var/www/html/public/apple-touch-icon.png
docker cp assets/coolify-logo.svg   coolify:/var/www/html/public/coolify-logo.svg
docker cp assets/login-logo.png     coolify:/var/www/html/public/login-logo.png

# 2 - rebrand all views (safe to re-run; case-sensitive sweep)
bash scripts/fix_titles.sh

# 3 - login logo component
docker cp views/components/auth/shell.blade.php \
  coolify:/var/www/html/resources/views/components/auth/shell.blade.php

# 4 - kill popups (safe to re-run)
bash scripts/fix-popups.sh

# 5 - APP_NAME on the host + re-cache config (restarts the container)
bash scripts/fix_appname.sh

# 6 - clear compiled views
docker exec coolify php artisan view:clear
```

Then verify: open `https://studio.merqato.digital` ??? title shows
`[Palawan Collective]`, no "Coolify" text, turtle on the login page
(incognito window), zero popups.

## Script notes

- `scripts/fix_titles.sh` ??? case-sensitive sweep `Coolify` ??? `Palawan
  Collective` over `/var/www/html/resources/views` inside the container.
- `scripts/fix-popups.sh` ??? forces `sponsorship/notification/realtime`
  popups off in `livewire/layout-popups.blade.php`.
- `scripts/fix_appname.sh` ??? quotes `APP_NAME`, runs `config:cache`,
  restarts the container.
- `scripts/make_favicon.ps1` ??? rebuilds `favicon.ico` + `apple-touch-icon.png`
  from the source PNG (`palawan (1)/2.png`).

## Ops gotchas (learned the hard way)

- **Cloudflare SSL mode must stay `Flexible`** ??? the origin rewrite sends
  traffic to port 8880, which is plain HTTP. Any switch to `Full` = HTTP 525
  "site down" (happened 2026-10-09, fixed via the Cloudflare dashboard SSL
  panel).
- Port **6001** (real-time) is blocked by the UpCloud trial firewall and
  cannot be opened ??? hence the popup kill in item 4.
- Coolify's UI toasts are dead for the same 6001 reason ??? verify actions
  server-side (DB/audit log) when in doubt.
- Branding/title changes revert on Coolify self-update ??? re-run this list.
