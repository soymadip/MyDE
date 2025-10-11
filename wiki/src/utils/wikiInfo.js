"use strict";

const fs = require("fs");
const path = require("path");

const DEFAULT_VERSION = "0.0.0";
const DEFAULT_WIKI_NAME = "My Wiki";

/**
 * Cached package information to avoid repeated fs reads.
 * - pkgLoaded indicates we've attempted to read package.json (successful or not).
 * - version / name hold fallback values if package.json can't be read.
 */
const cache = {
  pkgLoaded: false,
  version: null,
  name: null,
};

/**
 * Load package.json once and populate the cache.
 * Uses sensible fallbacks if package.json is missing or malformed.
 * This function is idempotent.
 * @private
 */
function loadPkgInfo() {
  if (cache.pkgLoaded) {
    return;
  }

  try {
    const pkgPath = path.resolve(__dirname, "../../package.json");
    const raw = fs.readFileSync(pkgPath, "utf8");
    const pkg = JSON.parse(raw);

    cache.version =
      typeof pkg.version === "string" && pkg.version.trim()
        ? pkg.version.trim()
        : DEFAULT_VERSION;

    // Prefer a human-facing 'displayName' or 'title' if present, then 'name'
    cache.name =
      (pkg.displayName && String(pkg.displayName).trim()) ||
      (pkg.title && String(pkg.title).trim()) ||
      (pkg.name && String(pkg.name).trim()) ||
      DEFAULT_WIKI_NAME;
  } catch (err) {
    cache.version = DEFAULT_VERSION;
    cache.name = DEFAULT_WIKI_NAME;

    console.warn(
      "[WARN] Could not read package.json for wiki info:",
      err.message,
    );
  } finally {
    cache.pkgLoaded = true;
  }
}

/**
 * Return the wiki/application version (cached).
 * If package.json can't be read, returns DEFAULT_VERSION.
 * @returns {string}
 */
function wikiVersion() {
  if (cache.version !== null && cache.pkgLoaded) {
    return cache.version;
  }

  loadPkgInfo();
  console.info("[INFO] Wiki version:", cache.version);
  return cache.version;
}

/**
 * Return the wiki name (cached).
 * Tries to use package.json fields `displayName`, `title`, or `name`.
 * Falls back to DEFAULT_WIKI_NAME if none are available.
 * @returns {string}
 */
function wikiName() {
  if (cache.name !== null && cache.pkgLoaded) {
    return cache.name;
  }

  loadPkgInfo();
  console.info("[INFO] Wiki name:", cache.name);
  return cache.name;
}

/**
 * Clears the cached values. Useful for tests or when package.json may change
 * during the lifetime of the process and you want to reload it.
 */
function clearWikiInfoCache() {
  cache.pkgLoaded = false;
  cache.version = null;
  cache.name = null;
}

module.exports = {
  wikiVersion,
  wikiName,
  clearWikiInfoCache,
};
