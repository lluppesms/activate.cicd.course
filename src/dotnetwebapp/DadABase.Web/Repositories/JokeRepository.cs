//-----------------------------------------------------------------------
// <copyright file="JokeRepository.cs" company="Luppes Consulting, Inc.">
// Copyright 2024, Luppes Consulting, Inc. All rights reserved.
// </copyright>
// <summary>
// Joke Repository
// </summary>
//-----------------------------------------------------------------------
namespace DadABase.Data;

/// <summary>
/// Joke Repository
/// </summary>
[ExcludeFromCodeCoverage]
public class JokeRepository : BaseRepository, IJokeRepository
{
    /// <summary>
    /// List of Jokes
    /// </summary>
    private static JokeList JokeData = new();

    /// <summary>
    /// List of Categories
    /// </summary>
    private static List<string> JokeCategories = new();

    /// <summary>
    /// Source of JSON Jokes
    /// </summary>
    private static readonly string sourceFileName = "Data/Jokes.json";

    /// <summary>
    /// Joke Repository
    /// </summary>
    public JokeRepository()
    {
        // load up the jokes into memory
        using (var r = new StreamReader(sourceFileName))
        {
            var json = r.ReadToEnd();
            JokeData = JsonConvert.DeserializeObject<JokeList>(json);
        }

        // select distinct categories from JokeData
        JokeCategories = JokeData.Jokes.Select(joke => joke.JokeCategoryTxt).Distinct().Order().ToList();
    }

    /// <summary>
    /// Get a random joke
    /// </summary>
    /// <param name="requestingUserName">Requesting UserName</param>
    /// <returns>Record</returns>
    public Joke GetRandomJoke(string requestingUserName = "ANON" )
    {
        var joke = JokeData.Jokes[Random.Shared.Next(0, JokeData.Jokes.Count)];
        //return joke ?? new Joke("No jokes here!");
        return (joke == null) ? new Joke("No jokes here!") : new Joke(joke.JokeTxt, joke.JokeCategoryTxt);
    }

    /// <summary>
    /// Find Matching Jokes by Search Text and Category
    /// </summary>
    /// <param name="searchTxt">Search Text</param>
    /// <param name="jokeCategoryTxt">Category</param>
    /// <param name="requestingUserName">Requesting UserName</param>
    /// <returns>Records</returns>
    public IQueryable<Joke> SearchJokes(string searchTxt = "", string jokeCategoryTxt = "", string requestingUserName = "ANON")
    {
        List<string> jokeCategoryList = null;
        jokeCategoryTxt = jokeCategoryTxt.Equals("All", StringComparison.OrdinalIgnoreCase) ? string.Empty : jokeCategoryTxt;

        if (!string.IsNullOrEmpty(jokeCategoryTxt))
        {
            // split the jokeCategoryTxt into a list of categories by comma
            var jokeCategoryArray = jokeCategoryTxt.Split(',').ToList();
            jokeCategoryList = JokeCategories.Where(category => jokeCategoryArray.Contains(category)).Select(c => c).ToList();
        }

        // user supplied both category and search term
        if (!string.IsNullOrEmpty(jokeCategoryTxt) && !string.IsNullOrEmpty(searchTxt))
        {
            var jokesByTermAndCategory = JokeData.Jokes
                .Where(joke => jokeCategoryList.Any(category => category == joke.JokeCategoryTxt)
                    && joke.JokeTxt.Contains(searchTxt, StringComparison.InvariantCultureIgnoreCase))
                .ToList();
            return jokesByTermAndCategory.AsQueryable();
        }

        // user supplied ONLY category and NOT search term
        if (!string.IsNullOrEmpty(jokeCategoryTxt) && string.IsNullOrEmpty(searchTxt))
        {
            var jokesInCategory = JokeData.Jokes
            .Where(joke => jokeCategoryList.Any(category => category == joke.JokeCategoryTxt))
            .ToList();
            return jokesInCategory.AsQueryable();
        }

        // user supplied NOT category and ONLY search term
        if (string.IsNullOrEmpty(jokeCategoryTxt) && !string.IsNullOrEmpty(searchTxt))
        {
            var jokesByTerm = JokeData.Jokes.Where(joke => joke.JokeTxt.Contains(searchTxt, StringComparison.InvariantCultureIgnoreCase)).ToList();
            return jokesByTerm.AsQueryable();
        }

        // user supplied NEITHER category NOR search term - get a random joke
        var randomJoke = GetRandomJoke();
        return new List<Joke> { randomJoke }.AsQueryable();
    }

    /// <summary>
    /// List All Jokes
    /// </summary>
    /// <returns>List of Category Names</returns>
    public IQueryable<Joke> ListAll(string activeInd = "Y", string requestingUserName = "ANON")
    {
        var jokesByTerm = JokeData.Jokes.ToList();
        return jokesByTerm.AsQueryable();
    }

    /// <summary>
    /// Get Joke Categories
    /// </summary>
    /// <returns>List of Category Names</returns>
    public IQueryable<string> GetJokeCategories(string activeInd, string requestingUserName)
    {
        return JokeCategories.AsQueryable();
    }

    /// <summary>
    /// Get One Record - not working in JSON!!!
    /// </summary>
    /// <param name="id"></param>
    /// <param name="requestingUserName"></param>
    /// <returns></returns>
    /// <exception cref="NotImplementedException"></exception>
    public Joke GetOne(int id, string requestingUserName = "ANON")
    {
        throw new NotImplementedException();
    }

    //// --------------------------------------------------------------------------------------------------------------
    ////  NOT IMPLEMENTED YET!
    //// --------------------------------------------------------------------------------------------------------------
    //public bool DupCheck(int keyValue, string dscr, ref string fieldName, ref string errorMessage)
    //{
    //    throw new NotImplementedException();
    //}

    //public bool Add(Joke Joke, string requestingUserName = "ANON")
    //{
    //    throw new NotImplementedException();
    //}

    //public bool DeleteCheck(int id, ref string errorMessage, string requestingUserName = "ANON")
    //{
    //    throw new NotImplementedException();
    //}

    //public bool Delete(int id, string requestingUserName = "ANON")
    //{
    //    throw new NotImplementedException();
    //}

    //public bool Save(int id, Joke joke, string requestingUserName = "ANON")
    //{
    //    throw new NotImplementedException();
    //}

    //public decimal AddRating(JokeRating jokeRating, string requestingUserName = "ANON")
    //{
    //    throw new NotImplementedException();
    //}

    ///// <summary>
    ///// Export Data
    ///// </summary>
    ///// <returns>Success</returns>
    //public bool ExportData(string fileName)
    //{
    //    using (var r = new StreamReader(sourceFileName))
    //    {
    //        var json = r.ReadToEnd();
    //        using (var w = new StreamWriter(fileName))
    //        {
    //            w.Write(json);
    //        }
    //    }
    //    return true;
    //}

    ///// <summary>
    ///// Import Data
    ///// </summary>
    ///// <returns>Success</returns>
    //public bool ImportData(string data)
    //{
    //    throw new NotImplementedException();
    //    // -- this *should* work, but hasn't been tested and we'd had to put in a file upload capability...
    //    //using (var w = new StreamWriter(sourceFileName))
    //    //{
    //    //    w.Write(data);
    //    //}
    //    //return true;
    //}

    /// <summary>
    /// Dispose
    /// </summary>
    /// <exception cref="NotImplementedException"></exception>
    public void Dispose()
    {
        throw new NotImplementedException();
    }
}