# Palawan Collective / MerQato Digital — Platform Master Inventory
**Owner lane: assistant · Last verified: 10 Oct 2026 · Living document**

## Identity map (who owns what)
| Platform | Account / login | Email | Notes |
|---|---|---|---|
| GitHub | `sanvicpalawan` (personal) | merqatodigital@proton.me | created 7 Sep 2026 · 2FA status UNVERIFIED |
| Vercel | scope `merqatodigital-7601` | — | CLI logged in locally |
| Cloudflare (dash) | account `4322261acf290539b992fbd803039ca7` | — | zone merqato.digital (active) |
| Cloudflare (wrangler) | account `2a51cf4fe2181cb0085fe8ffb9960009` | merqato.digital@gmail.com | SECOND account — confirm owner |
| Neon | org `org-rough-haze-98678005` | — | 12 projects |
| UpCloud | VPS 95.111.195.112 (Singapore) | — | NO API token/CLI — manual only |
| Coolify | owner david@palawancollective.com | — | Hermes lane (studio.merqato.digital) |
| Hostinger | domain registrar (dns-parking.com NS) | — | holds palawancollective.com |

## Cloudflare — 2 zones
| Zone | Status | NS | Verdict |
|---|---|---|---|
| merqato.digital | active (free) | james/aliza.ns.cloudflare.com | ✅ working, SSL=Flexible (required — plain-HTTP Coolify origin) |
| palawancollective.com | **active** (free) | james/aliza.ns.cloudflare.com (delegated from Hostinger 10 Oct) | ✅ **FIXED** — apex+www → 76.76.21.21 (Vercel, proxied); SSL default Full(strict) correct for Vercel; Hostinger email records (MX/DKIM/SPF/DMARC) preserved. Leftover parking-IP records: host., office. (cleanup candidates) |

## Vercel — 10 projects, 0 custom domains (all on *.vercel.app)
| Project | Production URL | Last update |
|---|---|---|
| azarraga-app-official | azarragaglass.vercel.app | 3h |
| palawancollective | palawancollective.vercel.app | 21h |
| retro-site-portfolio | retro-site-portfolio-merqatodigital-7601.vercel.app | 4d |
| updated-agency-platform | sanvicagent.vercel.app | 4d |
| fusion-updated | fusion-updated.vercel.app | 12d |
| merqato-digital | merqato-digital.vercel.app | 15d |
| mer-qato-lead-ops | mer-qato-lead-ops-puce.vercel.app | 19d |
| nebula-quest-launch | nebula-quest-launch.vercel.app | 23d |
| jayceetrading | jaycee-trading.vercel.app | 23d |
| sanvicph | sanvicph-lyart.vercel.app | 28d |

## GitHub — 22 repos (sanvicpalawan)
**Active**: coolify (studio + coolify-patches), palawancollective (site), sanvicph-neon (SANVIC 2027 map),
sanvicph (map), updated-agency-platform (TALA/NYX/HERMES), tala-agent (priv), baia-lodge-pms,
azarraga-app-official, kapwa-resort-os / kapwa-resort-webapp / kapwa-hospitality-os,
retro-site-portfolio, nebula-quest-launch, fusion-updated-, merqato.digital, guni-guni,
digital-agency, omnipresent-web (priv), jayceetrading (priv)
**Forks**: coolify (coollabsio — main is ours), openlivery (sarrazola), palawancollective-chat (LibreChat), FusionClaw

## Neon — 12 projects (all aws-ap-southeast-1, PG18, scale-to-zero 0.25 CU)
| Project | Created | Storage |
|---|---|---|
| sanvic.ph | Oct 8 | 31 MB |
| tala-agent | Oct 5 | 31 MB |
| portfolio-sites-retro site | Oct 5 | 34 MB |
| BAIA-updated-Oct2 | Oct 2 | 30 MB |
| sbi-animal-clinic-site | Oct 1 | 31 MB |
| Palawan Collective Official | Sep 29 | 33 MB |
| BAIA new HAIP | Sep 28 | 30 MB |
| fusion-updated- | Sep 27 | 33 MB |
| agency-site-official | Sep 23 | 31 MB |
| azarraga-glass-app | Sep 21 | 72 MB |
| tala-landing | Sep 17 | 31 MB |
| jaycee new site | Sep 14 | 31 MB |

## UpCloud
- VPS 95.111.195.112 (Singapore) — Ubuntu + Docker + Coolify. Firewall trial-locked (22/80/443/3389/8443/8880).
- No API credentials anywhere → everything at server level is manual.

## Issues (ranked)
1. ~~🔴 palawancollective.com is DEAD~~ ✅ RESOLVED 10 Oct: NS → Cloudflare, DNS → Vercel, cert issued, site 200 end-to-end.
2. 🟡 Agency site hosted TWICE: Vercel (now serving the .com) + Coolify (palawancollective app on our VPS) — canonical decided FOR NOW = Vercel for the .com; revisit when the studio VPS becomes primary.
3. 🟡 Identity spread across ≥4 emails (proton, gmail ×2, david@palawancollective.com) — no vault, 2FA unverified.
4. 🟡 No UpCloud API token — no automated VPS backup/monitoring possible.
5. 🟢 Vercel has no custom domains — projects only reachable on vercel.app URLs.
6. 🟢 Neon has near-duplicates (BAIA ×2) — low cost, cleanup later.
7. 🟢 Two Cloudflare accounts in play — confirm both are ours.

## Decisions pending (owner)
- [x] What should palawancollective.com do? → CHOICE 2: serve the Vercel site (done 10 Oct)
- [ ] Canonical agency site long-term: Vercel vs self-hosted Coolify (Vercel now live on .com; Coolify copy still runs on the VPS)
- [ ] Create UpCloud API user for automation?
