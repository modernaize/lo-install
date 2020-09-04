export version=D-develop

export POSTGRES_VERSION=$version
export SERVICE_VERSION=$version
export UI_VERSION=$version
export ML_VERSION=$version
export LIC_VERSION=$version
export UI_SCENARIO_VERSION=$version
# UI extensions
export UI_DASHBOARDS_VERSION=$version
export UI_WDC_VERSION=$version
export UI_EXTENSIONS=$version
export UI_BUSINESS_GRAMMAR=$version
export UI_DYK=$version

docker-compose up -d
