const sidebar = {
  Docs: [
    {
      label: "Getting Started",
      type: "category",
      link: {
        type: "doc",
        id: "index",
      },
      items: ["get-started/install", "get-started/post-installation"],
    },
    {
      label: "User Guide",
      type: "category",
      items: [
        "user-guide/keybinds",
        "user-guide/configuration",
        "user-guide/applications",
        "user-guide/myctl",
      ],
    },
    {
      label: "Developer Guide",
      type: "category",
      items: ["dev-guide/myctl-modules"],
    },
    "contributing",
    "faq",
  ],
};

export default sidebar;
