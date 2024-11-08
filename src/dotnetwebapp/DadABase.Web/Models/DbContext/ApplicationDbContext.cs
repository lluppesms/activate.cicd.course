//-----------------------------------------------------------------------
// <copyright file="ApplicationDbContext.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// Application Database Context
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.Data;

/// <summary>
/// Application Database Context
/// </summary>
/// <param name="options"></param>
[ExcludeFromCodeCoverage]
public class ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : IdentityDbContext<ApplicationUser>(options)
{
    /// <summary>
    /// On Model Creating
    /// </summary>
    /// <param name="builder">Builder</param>
    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
        // Customize the ASP.NET Identity model and override the defaults if needed.
        // For example, you can rename the ASP.NET Identity table names and more.
        // Add your customizations after calling base.OnModelCreating(builder);
    }
}

