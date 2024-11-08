//-----------------------------------------------------------------------
// <copyright file="CategoryController.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// Category Controller
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.API;

using Microsoft.AspNetCore.Authorization;
using RouteAttribute = Microsoft.AspNetCore.Mvc.RouteAttribute;

/// <summary>
/// Category API Controller
/// </summary>
[Route("api/[controller]")]
[ApiController]
[AllowAnonymous]
[ApiKey]
//[Authorize] <- this forces the user to be logged in, Anonymous+ApiKey allows logged in access OR access with just an API key
public class CategoryController : BaseAPIController
{
    #region Initialization
    /// <summary>
    /// Joke Repository
    /// </summary>
    public IJokeRepository JokeRepo { get; private set; }

    /// <summary>
    /// Joke API Controller (for unit tests)
    /// </summary>
    /// <param name="settings">Settings</param>
    /// <param name="contextAccessor">Context</param>
    /// <param name="jokeRepo">Repository</param>
    public CategoryController(AppSettings settings, IHttpContextAccessor contextAccessor, IJokeRepository jokeRepo)
    {
        SetupAutoMapper();
        context = contextAccessor;
        AppSettingsValues = settings;
        AppSettingsValues.UserName = GetUserName();
        JokeRepo = jokeRepo;
    }
    #endregion

    /// <summary>
    /// Get List of Categories
    /// </summary>
    /// <returns>Jokes</returns>
    [HttpGet]
    [Route("[action]")]
    public List<string> List()
    {
        var userName = GetUserName();
        var categories = JokeRepo.GetJokeCategories(userName);
        return categories.ToList();
    }
}
