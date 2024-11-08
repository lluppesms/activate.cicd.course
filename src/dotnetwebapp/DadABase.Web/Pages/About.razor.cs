//-----------------------------------------------------------------------
// <copyright file="About.razor.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// About Page Code-Behind
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.Web.Pages;

/// <summary>
/// About Page Code-Behind
/// </summary>
public partial class About : ComponentBase
{
    [Inject] IJSRuntime JsInterop { get; set; }

    /// <summary>
    /// Initialization
    /// </summary>
    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        await base.OnAfterRenderAsync(firstRender);

        if (firstRender)
        {
            await JsInterop.InvokeVoidAsync("syncHeaderTitle");
        }
    }
}
