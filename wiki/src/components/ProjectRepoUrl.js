import useDocusaurusContext from "@docusaurus/useDocusaurusContext";

export default function ProjectRepoUrl() {
  const {
    siteConfig: {
      customFields: { projectRepo },
    },
  } = useDocusaurusContext();
  return <>{projectRepo}</>;
}
