# Emberline

**Harmonised MODIS + VIIRS burning-activity calendars for any area on Earth.**
Built for the NASA Space Apps Challenge 2026, *Harmonization of MODIS and VIIRS hot spots*.

Satellites have tracked active fire hotspots since 2000, but the record is split between
MODIS (2000–, 1 km) and VIIRS (2012–, 375 m). On real NASA FIRMS data over Australia
(9 Sep – 18 Oct 2026) VIIRS reports **15.7×** as many fire pixels as MODIS for the same
fires, and counting every VIIRS satellite overstates burning area by **+169 %**. Both MODIS
satellites have also drifted far from their design overpass times. A naive stitch of the
two records invents trends. Emberline converts both to daily burning presence on a shared
grid, removes industrial heat sources, calibrates VIIRS to MODIS by region and land cover,
and turns the result into a calendar: typical season, percentile bands, critical period,
anomaly flags, an agricultural / wildfire split, a 1–4 week outlook with its measured skill,
uncertainty bands, and calendar files you can import into Google Calendar or Outlook.

| Evidence | Result |
|---|---|
| Real, held-out weeks (Australia, 5 satellites) | harmonised **6.4 %** weekly error vs naive **174 %** |
| Real, static-source filter vs FIRMS labels (India) | recall **90.7 %**, precision **87.8 %**, 0.5 % vegetation lost |
| Real, 1-week outlook vs typical-year guess (MODIS 2005–19 hindcast) | **+5 % to +25 %** error reduction by state; fades by 4 weeks |
| Simulated 25-yr record vs known truth | trend **1.30 %/yr** vs truth 1.32 (naive 4.17); step at 2012 −0.7 % (naive +64 %) |

Details: [docs/VALIDATION.md](docs/VALIDATION.md) · sources and citations: [docs/DATA_SOURCES.md](docs/DATA_SOURCES.md) ·
design: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) · setup: [docs/DEVELOPING.md](docs/DEVELOPING.md)

## Quick start

```bash
make setup data all     # install, fetch real inputs, run everything, build the page
make serve              # http://localhost:8000
```

## What's in the box

```
emberline/            pipeline package (ingest, grid, filters, presence, calibrate, harmonize,
                      events, climatology, aoi, validate, api, cli, simulate)
emberline/sources/    FIRMS key-less feeds, FireWatch mirror, IBM MODIS history, Natural Earth
scripts/              run_demo · run_australia · run_india · validate_static_real · build_web · fetch_real_data.sh
web/template.html     Leaflet + D3 + three.js app (NASA Blue Marble globe, calendars, draw-your-own-area)
tests/                29 tests: unit, sources, end-to-end on simulated truth, API
.github/workflows/    CI and a 6-hourly live FIRMS refresh → GitHub Pages
Dockerfile Makefile .devcontainer/
```

## Acknowledgements

We acknowledge the use of data and imagery from NASA's Fire Information for Resource
Management System (FIRMS), part of NASA's Earth Science Data and Information System
(ESDIS). Earth imagery: NASA Visible Earth (Blue Marble) and NASA Earth Observatory
(Earth at Night). Boundaries: Natural Earth. FIRMS NRT mirror: WvR-Spatial/FireWatch
(MIT). Full list in docs/DATA_SOURCES.md.
