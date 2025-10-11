import clsx from "clsx";
import Link from "@docusaurus/Link";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";

import Heading from "@theme/Heading";
import styles from "@site/src/css/index.module.css";
import useBaseUrl from "@docusaurus/useBaseUrl";

const Feature = ({ svg, title, description }) => (
  <div className={clsx("col col--4")}>
    <div className="text--center">
      <img src={useBaseUrl(svg)} className={styles.featureSvg} alt={title} />
    </div>
    <div className="text--center padding-horiz--md">
      <Heading as="h3">{title}</Heading>
      <p>{description}</p>
    </div>
  </div>
);

const Home = () => {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout title={siteConfig.title} description={siteConfig.tagline}>
      <header className={clsx("hero hero--primary", styles.heroBanner)}>
        <div className="container">
          <img
            src={siteConfig.customFields.projectIcon}
            alt="MyDE Icon"
            className={styles.hero__icon}
          />
          <Heading as="h1" className={clsx("hero__title", styles.hero__title)}>
            {siteConfig.title}
          </Heading>
          <p className={clsx("hero__subtitle", styles.hero__subtitle)}>
            {siteConfig.tagline}
          </p>
          <div className={styles.buttons}>
            <Link className="button button--secondary button--lg" to="/docs">
              Get Started 🚀
            </Link>
          </div>
        </div>
      </header>
      <main>
        <section className={styles.features}>
          <div className="container">
            <div className="row">
              {(siteConfig?.customFields?.features || []).map((f, idx) => (
                <Feature
                  key={idx}
                  svg={f.svg}
                  title={f.title}
                  description={f.description}
                />
              ))}
            </div>
          </div>
        </section>
      </main>
    </Layout>
  );
};

export default Home;
