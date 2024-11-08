//-----------------------------------------------------------------------
// <copyright file="IJokeRepository.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// Joke Interface
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.Repositories;

/// <summary>
/// Joke Interface
/// </summary>
public interface IJokeRepository
{
    /// <summary>
    /// Find All Records
    /// </summary>
    /// <param name="activeInd">Active?</param>
    /// <param name="requestingUserName">Requesting UserName</param>
    /// <returns>Records</returns>
    IQueryable<Joke> ListAll(string activeInd = "Y", string requestingUserName = "ANON");

    /// <summary>
    /// Find One Specific Joke
    /// </summary>
    /// <param name="requestingUserName">Requesting UserName</param>
    /// <param name="id">id</param>
    /// <returns>Records</returns>
    Joke GetOne(int id, string requestingUserName = "ANON");

    /// <summary>
    /// Get a random joke
    /// </summary>
    /// <param name="requestingUserName">Requesting UserName</param>
    /// <returns>Record</returns>
    Joke GetRandomJoke(string requestingUserName = "ANON");

    /// <summary>
    /// Get Joke Categories
    /// </summary>
    /// <returns>List of Category Names</returns>
    IQueryable<string> GetJokeCategories(string activeInd = "Y", string requestingUserName = "ANON");

    /// <summary>
    /// Find Records by Search Text and/or Category
    /// </summary>
    /// <param name="searchTxt">Search</param>
    /// <param name="jokeCategoryTxt">Category</param>
    /// <param name="requestingUserName">Requesting UserName</param>
    /// <returns>Records</returns>
    IQueryable<Joke> SearchJokes(string searchTxt, string jokeCategoryTxt, string requestingUserName = "ANON");

    /// <summary>
    /// Disposal
    /// </summary>
    void Dispose();
}
