<%@ Page Language="C#" %>

<%@ OutputCache Location="None" VaryByParam="none" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Net.Sockets" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Xml.Linq" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System" %>
<!DOCTYPE html>

<script runat="server">
    const string _connectionStringName = "database";
    const string _sql = "select @@servername";
    const string _unableToConnect = "NO CONNECTION";
    string inSite_Commerce = _unableToConnect;
    string exigoContext = _unableToConnect;
    string errorMessage = null;
    bool success = false;
    string webConfig;
    string exigoApiSoap;
    string exigoAdminApiSoap;
    string buildInfo;
    string projectName;
    string shortCommitId;
    string commitDateUTC;
    string address1;
    string address2;
    string inSite_Commerce2;
    string exigoContext2;
    

    public void page_load(object sender, EventArgs e)
    {
        success = false;

        Page.DataBind();
        XElement _webConfig;
        XElement _exigoApiSoap;
        XElement _exigoAdminApiSoap;
        XElement _buildInfo;
        XElement _projectName;
        XElement _shortCommitId;
        XElement _commitDateUTC;
        XNamespace _ns1;
        XNamespace _ns2;
        XElement _connectionConfig;
        string _inSite_Commerce;
        string _exigoContext;
        string _basePath = @"C:\_Web\nerium.com\Nerium.Web";

        // Loading the document and getting the endpoint inside Web.config
          _webConfig = XElement.Load(_basePath + @"\web.config");
        //_webConfig = XElement.Load(@"C:\Users\bnguyen\Desktop\healthcheck\web2.config");
        _exigoApiSoap = _webConfig.Descendants("endpoint")
            .FirstOrDefault(el => el.Attribute("name") != null &&
                                  el.Attribute("name").Value == "ExigoApiSoap");
        // Getting value inside _exigoApiSoap with name address
        address1 = _exigoApiSoap.Attribute("address").Value;

        // Getting the endpoint2 inside Web.config
        _exigoAdminApiSoap = _webConfig.Descendants("endpoint")
            .FirstOrDefault(el => el.Attribute("name") != null &&
                                  el.Attribute("name").Value == "ExigoAdminApiSoap");
        // Getting value inside _exigoAdminApiSoap with name address
        address2 = _exigoAdminApiSoap.Attribute("address").Value;

        // Setting the namespace inside buildInfo.config
        _ns1 = "http://schemas.microsoft.com/VisualStudio/DeploymentEvent/2013/06";
        _ns2 = "http://schemas.microsoft.com/visualstudio/deploymentevent_git/2013/09";

        // Loading the document and getting the Projectname, ShortCommitId and Date from buildInfo.config
        _buildInfo = XElement.Load(_basePath + @"\bin\_PublishedWebsites\Nerium.Web\buildInfo.config");
        //_buildInfo = XElement.Load(@"C:\Users\bnguyen\Desktop\healthcheck\buildInfo.config");
        _projectName = _buildInfo.Element(_ns1 + "ProjectName");
        _shortCommitId = _buildInfo.Element(_ns1 + "SourceControl").Element(_ns2 + "GitSourceControl").Element(_ns2 + "ShortCommitId");
        _commitDateUTC = _buildInfo.Element(_ns1 + "SourceControl").Element(_ns2 + "GitSourceControl").Element(_ns2 + "CommitDateUTC");

        // Loading the document and getting the endpoint inside Web.config
        _connectionConfig = XElement.Load(_basePath + @"\App_Config\ConnectionStrings.config");
        //_connectionConfig = XElement.Load(@"C:\Users\bnguyen\Desktop\healthcheck\ConnectionStrings.config");
        _inSite_Commerce = _connectionConfig.Descendants("add")
            .FirstOrDefault(el => el.Attribute("name") != null &&
                                  el.Attribute("name").Value == "InSite.Commerce").Attribute("connectionString").Value;

        _exigoContext = _connectionConfig.Descendants("add")
            .FirstOrDefault(el => el.Attribute("name") != null &&
                                  el.Attribute("name").Value == "ExigoContext").Attribute("connectionString").Value;

        // Assigned the local variables from XElement to the global ones as strings
        exigoApiSoap = _exigoApiSoap.FirstAttribute.NextAttribute.Value;
        exigoAdminApiSoap = _exigoAdminApiSoap.FirstAttribute.NextAttribute.Value;
        projectName = _projectName.Value;
        shortCommitId = _shortCommitId.Value;
        commitDateUTC = _commitDateUTC.Value;
        inSite_Commerce2 = _inSite_Commerce;
        exigoContext2 = _exigoContext;
        
        inSite_Commerce = DatabaseName2();
        exigoContext = DatabaseName3();
    }


    string DatabaseName2()
    {
        var serverName = _unableToConnect;
        try
        {
            using (SqlConnection conn = new SqlConnection(inSite_Commerce2))
            {
                using (SqlCommand cmd = new SqlCommand(_sql, conn))
                {
                    conn.Open();
                    var result = cmd.ExecuteScalar();
                    serverName = result == null ? _unableToConnect : result.ToString();
                    success = true;
                }
            }
        }
        catch (Exception ex)
        {
            Response.StatusCode = 500;
            success = false;
            serverName = _unableToConnect;
            errorMessage = ex.ToString();
        }
        return serverName;
    }

    string DatabaseName3()
    {
        var serverName = _unableToConnect;
        try
        {
            using (SqlConnection conn = new SqlConnection(exigoContext2))
            {
                using (SqlCommand cmd = new SqlCommand(_sql, conn))
                {
                    conn.Open();
                    var result = cmd.ExecuteScalar();
                    serverName = result == null ? _unableToConnect : result.ToString();
                    success = true;
                }
            }
        }
        catch (Exception ex)
        {
            Response.StatusCode = 500;
            success = false;
            serverName = _unableToConnect;
            errorMessage = ex.ToString();
        }
        return serverName;
    }
    
  
    
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Nerium Verification Check</title>
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" />
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <p><b style="font-size: 24px"%><%=projectName%></b></p>
            <h4>Insite Commerce: <small><b class="text-<%=inSite_Commerce=="NO CONNECTION" ? "danger" : "success"%>"><%=inSite_Commerce%></b></small></h4>
            <h4>ExigoContext: <small><b class="text-<%=exigoContext=="NO CONNECTION" ? "danger" : "success"%>"><%=exigoContext%></b></small></h4>
            <h4>ExigoApiSoap: <small><%=exigoApiSoap%></small></h4>
            <h4>ExigoAdminApiSoap: <small><%=exigoAdminApiSoap%></small></h4>
            <h4>Commit: <small><%=shortCommitId%></small></h4>
            <h4>Commit Date: <small><%=commitDateUTC%></small></h4>
        </div>
    </form>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
</body>
</html>
