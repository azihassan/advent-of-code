import std;

void main()
{
    string[] grid = stdin.byLine.map!idup.map!strip.array;
    grid.countOccurrence("XMAS").writeln();
}

long countOccurrence(string[] haystack, string needle)
{
    int occurrenceCount = 0;
    foreach(y; 0 .. haystack.length)
    {
        foreach(x; 0 .. haystack[y].length)
        {
            occurrenceCount += haystack.checkRow(needle, cast(int) x, cast(int) y);
            occurrenceCount += haystack.checkColumn(needle, cast(int) x, cast(int) y);
            occurrenceCount += haystack.checkDiagonal(needle, cast(int) x, cast(int) y);
        }
    }
    return occurrenceCount;
}

int checkRow(string[] haystack, string needle, int x, int y)
{
    int matches;
    string word;
    for(int _x = x, i = 0; i < needle.length; _x++, i++)
    {
        if(haystack.isWithinBounds(_x, y))
        {
            word ~= haystack[y][_x];
        }
    }
    matches += word == needle;

    word = "";
    for(int _x = x, i = 0; i < needle.length; _x--, i++)
    {
        if(haystack.isWithinBounds(_x, y))
        {
            word ~= haystack[y][_x];
        }
    }
    matches += word == needle;
    return matches;
}

int checkColumn(string[] haystack, string needle, int x, int y)
{
    int matches;
    string word;
    for(int _y = y, i = 0; i < needle.length; _y++, i++)
    {
        if(haystack.isWithinBounds(x, _y))
        {
            word ~= haystack[_y][x];
        }
    }
    matches += word == needle;

    word = "";
    for(int _y = y, i = 0; i < needle.length; _y--, i++)
    {
        if(haystack.isWithinBounds(x, _y))
        {
            word ~= haystack[_y][x];
        }
    }
    matches += word == needle;
    return matches;
}

int checkDiagonal(string[] haystack, string needle, int x, int y)
{
    int matches;
    string word;
    for(int _y = y, _x = x, i = 0; i < needle.length; _y++, _x++, i++)
    {
        if(haystack.isWithinBounds(_x, _y))
        {
            word ~= haystack[_y][_x];
        }
    }
    matches += word == needle;

    word = "";
    for(int _y = y, _x = x, i = 0; i < needle.length; _y--, _x++, i++)
    {
        if(haystack.isWithinBounds(_x, _y))
        {
            word ~= haystack[_y][_x];
        }
    }
    matches += word == needle;

    word = "";
    for(int _y = y, _x = x, i = 0; i < needle.length; _y--, _x--, i++)
    {
        if(haystack.isWithinBounds(_x, _y))
        {
            word ~= haystack[_y][_x];
        }
    }
    matches += word == needle;

    word = "";
    for(int _y = y, _x = x, i = 0; i < needle.length; _y++, _x--, i++)
    {
        if(haystack.isWithinBounds(_x, _y))
        {
            word ~= haystack[_y][_x];
        }
    }
    matches += word == needle;
    return matches;
}

int isWithinBounds(string[] haystack, size_t x, size_t y)
{
    return 0 <= y && y < haystack.length && 0 <= x && x < haystack[0].length;
}
