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
      ],
    },
    {
      label: "Developer Guide",
      type: "category",
      items: ["dev-guide/mycli-modules"],
    },
    "contributing",
    "faq",
  ],
};

export default sidebar;
