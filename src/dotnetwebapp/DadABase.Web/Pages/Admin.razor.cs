//-----------------------------------------------------------------------
// <copyright file="Admin.razor.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// Admin Page Code-Behind
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.Web.Pages;

/// <summary>
/// Admin Page Code-Behind
/// </summary>
public partial class Admin : ComponentBase
{
    [Inject] AppSettings Settings { get; set; }
    [Inject] HttpContextAccessor Context { get; set; }
    [Inject] IJSRuntime JsInterop { get; set; }

    private string userName = string.Empty;
    private string buildInfo = string.Empty;
    private string apiKeyInfo = string.Empty;

    /// <summary>
    /// Initialization
    /// </summary>
    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        await base.OnAfterRenderAsync(firstRender);

        if (firstRender)
        {
            await JsInterop.InvokeVoidAsync("syncHeaderTitle");
            var userIdentity = Context.HttpContext.User;
            userName = userIdentity != null ? userIdentity.Identity.Name : string.Empty;
            var isInAdminRole = userIdentity != null && userIdentity.IsInRole("Admin");
            if (isInAdminRole)
            {
                try
                {
                    var buildInfoFile = Path.Combine(Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location), "buildinfo.json");
                    if (File.Exists(buildInfoFile))
                    {
                        using (var r = new StreamReader(buildInfoFile))
                        {
                            var buildInfoData = r.ReadToEnd();
                            var buildInfoObject = JsonConvert.DeserializeObject<BuildInfo>(buildInfoData);
                            buildInfo = buildInfoObject.BuildNumber;
                        }
                    }
                    apiKeyInfo = string.IsNullOrEmpty(Settings.ApiKey) ? string.Empty : Settings.ApiKey[..1] + "...";
                }
                catch (Exception)
                {
                    buildInfo = "Build: Error reading buildinfo!";
                }
            }
            StateHasChanged();
        }
    }
}
