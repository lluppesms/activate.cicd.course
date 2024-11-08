//-----------------------------------------------------------------------
// <copyright file="AppSettings.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// Application Settings
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.Data;

/// <summary>
/// Application Settings
/// </summary>
[ExcludeFromCodeCoverage]
public class AppSettings
{
    /// <summary>
    /// App Version
    /// </summary>
    public string AppVersion { get; set; }

    /// <summary>
    /// App Title
    /// </summary>
    public string AppTitle { get; set; }

    /// <summary>
    /// App Description
    /// </summary>
    public string AppDescription { get; set; }

    /// <summary>
    /// Environment Name
    /// </summary>
    public string EnvironmentName { get; set; }

    /// <summary>
    /// User Name
    /// </summary>
    public string UserName { get; set; }

    /// <summary>
    /// Super User First Name
    /// </summary>
    public string SuperUserFirstName { get; set; }

    /// <summary>
    /// Super User Last Name
    /// </summary>
    public string SuperUserLastName { get; set; }

    /// <summary>
    /// Application Insights Key
    /// </summary>
    public string AppInsights_InstrumentationKey { get; set; }

    /// <summary>
    /// Generic API Key
    /// </summary>
    public string ApiKey { get; set; }

    /// <summary>
    /// Data Source
    /// </summary>
    public string DataSource { get; set; }

    /// <summary>
    /// Default Connection
    /// </summary>
    public string DefaultConnection { get; set; }

    /// <summary>
    /// Project Entities
    /// </summary>
    public string ProjectEntities { get; set; }

    /// <summary>
    /// Should I use the local database or the Azure one...?
    /// </summary>
    public bool EnableSwagger { get; set; }

    /// <summary>
    /// Application Settings
    /// </summary>
    public AppSettings()
    {
        UserName = string.Empty;
    }
}
