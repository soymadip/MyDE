import { catppuccinMocha, catppuccinLatte } from "./src/config/prism.js";
import {
  wikiVersion as wikiVer,
  wikiName as wikiNm,
} from "./src/utils/wikiInfo.js";
import { metaTags } from "./src/config/metaTags.js";
import { useEnabled } from "../wiki/src/utils/filterEnabledItems.js";
import roadmap from "./roadmap.js";

//========================= Config Vars =========================//

const projectName = "MyDE";

const projectTagLine =
  "A beautiful, customized Linux Desktop Environment that just works";
const iconPic =
  "https://raw.githubusercontent.com/soymadip/MyDE/refs/heads/main/src/img/icon.png";
const projectRepo = "https://github.com/soymadip/MyDE";

const siteUrl = "https://soymadip.github.io";
const sitePath = "/MyDE";

//========================= Docusaurus Config =========================//

const faviconPath = "favicon/favicon.ico";
const wikiVersion = `${wikiVer()}`;
const wikiName = `${wikiNm()}`;

const config = {
  projectName: projectName,

  title: projectName,

  tagline: projectTagLine,

  favicon: faviconPath,

  url: siteUrl,
  baseUrl: sitePath,

  // GH Pages config
  organizationName: projectName,
  deploymentBranch: "gh-pages",

  onBrokenAnchors: "ignore",
  onBrokenLinks: "warn",

  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  headTags: metaTags,

  customFields: {
    projectIcon: iconPic,
    projectRepo: projectRepo,

    robotsTxt: {
      enable: true,
      rules: [
        {
          disallow: ["/docs/", "/tasks/"],
        },
      ],
      customLines: [],
    },

    roadmap,

    features: [
      {
        title: "Dynamic Tiling",
        svg: "img/dynamic-tyling.svg",
        description:
          "Flexible dynamic-tiling window management designed to help you arrange and navigate windows faster and neatly.",
      },
      {
        title: "Focus on Efficiency",
        svg: "img/focus-on-efficiency.svg",
        description:
          "Keyboard-centric workflow with vim style binds so you can perform common actions quickly without leaving the keyboard.",
      },
      {
        title: "Curated Tools, Utilities",
        svg: "img/curated-tools.svg",
        description:
          "Carefully selected & created apps and CLI utilities note-taking, office tools, and terminal — chosen to work well together.",
      },
    ],
  },

  presets: [
    [
      "classic",
      {
        docs: {
          sidebarPath: "./.sidebar.js",
          breadcrumbs: true,
          admonitions: {
            extendDefaults: true,
          },
        },

        blog: {
          blogSidebarTitle: "Releases",

          path: "releases",
          routeBasePath: "releases",

          showReadingTime: false,

          feedOptions: {
            type: ["rss", "atom"],
            xslt: true,
          },

          onInlineTags: "warn",
          onInlineAuthors: "warn",
          onUntruncatedBlogPosts: "warn",
        },

        theme: {
          customCss: "./src/css/custom.css",
        },
      },
    ],
  ],

  markdown: {
    mermaid: true,
    hooks: {
      onBrokenMarkdownLinks: "warn",
    },
  },

  themeConfig: {
    // Social card
    image: "img/social-card.png",

    docs: {
      sidebar: {
        hideable: true,
      },
    },

    imageZoom: {
      options: {
        margin: 2,
        background: "rgba(var(--ifm-background-color-rgb), 0.9)",
      },
    },

    // Default: Dark mode
    colorMode: {
      respectPrefersColorScheme: true,
      defaultMode: "dark",
    },

    navbar: {
      title: `${projectName}`,
      hideOnScroll: true,

      logo: {
        alt: "Site Logo",
        src: `${faviconPath}`,
      },

      items: useEnabled([
        {
          label: "Docs",
          to: "/docs",
        },
        {
          label: "Releases",
          to: "/releases",
        },
        {
          type: "dropdown",
          label: "More",
          position: "left",
          className: "_navbar-more-items",
          items: useEnabled([
            { label: "Roadmap", to: "/roadmap" },
            {
              enable: true,
              value: {
                label: `${wikiName} v${wikiVersion}`,
                className: "_nav-wiki-version",
                to: `${projectRepo}/tree/main/wiki`,
              },
            },
          ]),
        },
        {
          type: "search",
          position: "right",
          className: "navbar-search-bar",
        },
        {
          href: projectRepo,
          // label: "GitHub",
          position: "right",
          className: "header-github-link",
          "aria-label": "GitHub repository",
        },
      ]),
    },

    tableOfContents: {
      minHeadingLevel: 2,
      maxHeadingLevel: 4,
    },

    prism: {
      theme: catppuccinLatte,
      darkTheme: catppuccinMocha,
      additionalLanguages: ["java", "php", "bash"],
    },

    footer: {
      /* links: [
        {
            label: 'GitHub',
            href: 'https://github.com/',
          }
        ],
        copyright: `Copyright © ${new Date().getFullYear()} ` + ownerName,
      */
    },
  },

  plugins: [
    require.resolve("./src/utils/generateFavicon"),
    require.resolve("./src/utils/generateRobotsTxt"),
    [
      require.resolve("@easyops-cn/docusaurus-search-local"),
      {
        hashed: true,
        indexDocs: true,
        docsDir: "docs",
        blogDir: "releases",
        docsRouteBasePath: "docs",
        highlightSearchTermsOnTargetPage: true,
        explicitSearchResultPath: true,
        hideSearchBarWithNoSearchContext: true,
        searchContextByPaths: ["docs", "releases"],
        language: ["en"],
      },
    ],
    "plugin-image-zoom",
  ],
};

export default config;
