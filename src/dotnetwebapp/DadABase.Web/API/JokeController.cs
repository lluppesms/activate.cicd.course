//-----------------------------------------------------------------------
// <copyright file="JokeController.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// Joke API Controller
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.API;

using DadABase.Repositories;
using Microsoft.AspNetCore.Authorization;
using RouteAttribute = Microsoft.AspNetCore.Mvc.RouteAttribute;

/// <summary>
/// Joke API Controller
/// </summary>
[Route("api/[controller]")]
[ApiController]
[AllowAnonymous]
[ApiKey]
//[Authorize] <- this forces the user to be logged in, Anonymous+ApiKey allows logged in access OR access with just an API key
public class JokeController : BaseAPIController
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
    public JokeController(AppSettings settings, IHttpContextAccessor contextAccessor, IJokeRepository jokeRepo)
    {
        SetupAutoMapper();
        context = contextAccessor;
        AppSettingsValues = settings;
        AppSettingsValues.UserName = GetUserName();
        JokeRepo = jokeRepo;
    }
    #endregion

    /// <summary>
    /// Get Random Joke
    /// </summary>
    /// <returns>Joke</returns>
    [HttpGet]
	[AllowAnonymous]
	public JokeBasic Get()
    {
        var userName = GetUserName();
        var joke = JokeRepo.GetRandomJoke(userName);
        var simplifiedJoke = iMapper.Map<JokeBasic>(joke);
        return simplifiedJoke;
    }

    /// <summary>
    /// Get List of Jokes
    /// </summary>
    /// <returns>Jokes</returns>
    [HttpGet]
    [Route("[action]")]
    public List<JokeBasic> List()
    {
        var userName = GetUserName();
        var jokes = JokeRepo.ListAll(userName);
        var simplifiedJokes = iMapper.Map<IEnumerable<Joke>, List<JokeBasic>>(jokes);
        return simplifiedJokes;
    }

    /// <summary>
    /// Get One Specific Joke
    /// </summary>
    /// <returns>Joke</returns>
    [HttpGet]
    [Route("{id}")]
    public JokeBasic GetOne(int id)
    {
        var userName = GetUserName();
        var joke = JokeRepo.GetOne(id, userName);
        var simplifiedJoke = iMapper.Map<JokeBasic>(joke);
        return simplifiedJoke;
    }

    /// <summary>
    /// Get Jokes by Category
    /// </summary>
    /// <param name="categoryTxt" example="Chickens">Category of Jokes</param>
    /// <returns>Jokes</returns>
    [HttpGet]
    [Route("category/{categoryTxt}")]
    public List<JokeBasic> Category(string categoryTxt)
    {
        var userName = GetUserName();
        var jokes = JokeRepo.SearchJokes(string.Empty, categoryTxt, userName);
        var simplifiedJokes = iMapper.Map<IEnumerable<Joke>, List<JokeBasic>>(jokes);
        return simplifiedJokes;
    }

    /// <summary>
    /// Search Jokes
    /// </summary>
    /// <param name="searchTxt" example="Bunny">A word that is in a joke</param>
    /// <returns>Jokes</returns>
    [HttpGet]
    [Route("search/{searchTxt}")]
    public List<JokeBasic> Search(string searchTxt)
    {
        var userName = GetUserName();
        var jokes = JokeRepo.SearchJokes(searchTxt, string.Empty, userName);
        var simplifiedJokes = iMapper.Map<IEnumerable<Joke>, List<JokeBasic>>(jokes);
        return simplifiedJokes;
    }

    /// <summary>
    /// Search Jokes within a Category
    /// </summary>
    /// <param name="categoryTxt" example="Chickens">Category of Jokes</param>
    /// <param name="searchTxt" example="Bunny">A word that is in a joke</param>
    /// <returns>Jokes</returns>
    [HttpGet]
    [Route("searchcategory/{categoryTxt}/{searchTxt}")]
    public List<JokeBasic> SearchCategory(string categoryTxt, string searchTxt)
    {
        var userName = GetUserName();
        var jokes = JokeRepo.SearchJokes(searchTxt, categoryTxt, userName);
        var simplifiedJokes = iMapper.Map<IEnumerable<Joke>, List<JokeBasic>>(jokes);
        return simplifiedJokes;
    }
}