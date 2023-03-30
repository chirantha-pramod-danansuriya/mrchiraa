param siteName string
param location string = resourceGroup().location
param githubUrl string


var serverFarmName = '${siteName}-asp'
var webAppName = '${siteName}-func'

resource serverFarm 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: serverFarmName
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}


resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: serverFarm.id
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.11'
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: githubUrl
        }
      ]
    }
    httpsOnly: true
  }
}

output webAppUrl string = webApp.properties.defaultHostName
