locals {
  api_config_id_prefix     = "api"
  api_gateway_container_id = "api-gw"
  gateway_id               = "gw"
}

resource "google_api_gateway_api" "api_gw" {
  provider     = google-beta
  api_id       = local.api_gateway_container_id
  display_name = "The Cloudresume API Gateway"

}

resource "google_api_gateway_api_config" "api_cfg" {
  provider      = google-beta
  api           = google_api_gateway_api.api_gw.api_id
  api_config_id_prefix = local.api_config_id_prefix
  display_name  = "The Cloudresume Config"

  openapi_documents {
    document {
      path     = "openapi2-run.yaml"
      contents = filebase64("openapi2-run.yaml")
    }
  }
}

resource "google_api_gateway_gateway" "gw" {
  provider   = google-beta
  region     = "us-central1"

  api_config   = google_api_gateway_api_config.api_cfg.id

  gateway_id   = local.gateway_id
  display_name = "The Cloudresume Gateway"

  depends_on = [google_api_gateway_api_config.api_cfg]
}