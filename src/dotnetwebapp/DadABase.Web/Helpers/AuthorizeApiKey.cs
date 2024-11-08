
//-----------------------------------------------------------------------
// <copyright file="AuthorizeApiKey.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// API Key Authorization Attribute
// </summary>
//-----------------------------------------------------------------------

using Microsoft.Extensions.Primitives;

namespace DadABase.Web.Attributes;

/// <summary>
/// API Key Authorization Attribute
/// </summary>
[ExcludeFromCodeCoverage]
[AttributeUsage(validOn: AttributeTargets.Class)]
public class ApiKeyAttribute : Attribute, IAsyncActionFilter
{
    private const string HeaderName = "ApiKey";

    /// <summary>
    /// Validate with API Key in Header or Query String
    /// </summary>
    public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
        // check to see if user is already logged in, if not look for API Key
        if (string.IsNullOrEmpty(context != null && context.HttpContext != null && context.HttpContext.User != null && context.HttpContext.User.Identity != null && context.HttpContext.User.Identity.Name != null ? context.HttpContext.User.Identity.Name : ""))
        {
            StringValues extractedApiKey = string.Empty;
            StringValues extractedQueryKey = string.Empty;

            // check for API Key in Header
            context.HttpContext.Request.Headers.TryGetValue(HeaderName, out extractedApiKey);
            if (string.IsNullOrEmpty(extractedApiKey))
            {
                // if not in Header, check for API Key in Query String
                context.HttpContext.Request.Query.TryGetValue(HeaderName, out extractedQueryKey);
            }

            // if no API Key found, then bounce
            if (string.IsNullOrEmpty(extractedApiKey) && string.IsNullOrEmpty(extractedQueryKey))
            {
                context.Result = new ContentResult() { StatusCode = StatusCodes.Status400BadRequest, Content = "Bad Request" };
                return;
            }

            // if API Key found, then validate
            var appSettings = context.HttpContext.RequestServices.GetRequiredService<AppSettings>();
            if (appSettings == null ||
                (!appSettings.ApiKey.Equals(extractedApiKey, StringComparison.CurrentCultureIgnoreCase) && !appSettings.ApiKey.Equals(extractedQueryKey, StringComparison.CurrentCultureIgnoreCase)))
            {
                context.Result = new ContentResult() { StatusCode = StatusCodes.Status401Unauthorized, Content = "Unauthorized" };
                return;
            }
        }
        await next();
    }
}