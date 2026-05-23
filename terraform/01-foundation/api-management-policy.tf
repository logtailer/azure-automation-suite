resource "azurerm_api_management_policy" "global" {
  count               = var.enable_apim ? 1 : 0
  api_management_id   = azurerm_api_management.main[0].id

  xml_content = <<-XML
    <policies>
      <inbound>
        <cors allow-credentials="false">
          <allowed-origins>
            <origin>*</origin>
          </allowed-origins>
          <allowed-methods>
            <method>GET</method>
            <method>POST</method>
            <method>PUT</method>
            <method>DELETE</method>
            <method>OPTIONS</method>
          </allowed-methods>
          <allowed-headers>
            <header>*</header>
          </allowed-headers>
        </cors>
        <rate-limit-by-key calls="1000" renewal-period="60"
          counter-key="@(context.Request.IpAddress)"
          increment-condition="@(context.Response.StatusCode != 429)" />
        <set-header name="X-Request-ID" exists-action="skip">
          <value>@(context.RequestId)</value>
        </set-header>
      </inbound>
      <backend>
        <forward-request timeout="30" />
      </backend>
      <outbound>
        <set-header name="X-Content-Type-Options" exists-action="override">
          <value>nosniff</value>
        </set-header>
        <set-header name="X-Frame-Options" exists-action="override">
          <value>DENY</value>
        </set-header>
        <set-header name="Strict-Transport-Security" exists-action="override">
          <value>max-age=31536000; includeSubDomains</value>
        </set-header>
      </outbound>
      <on-error>
        <return-response>
          <set-status code="500" reason="Internal Server Error" />
          <set-body>{"error": "An unexpected error occurred", "requestId": "@(context.RequestId)"}</set-body>
        </return-response>
      </on-error>
    </policies>
  XML
}
