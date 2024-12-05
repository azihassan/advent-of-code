import std;

void main()
{
    string[] grid = stdin.byLine.map!idup.map!strip.array;
    grid.countXMas().writeln();
}

long countXMas(string[] haystack)
{
    int occurrenceCount = 0;
    foreach(y; 1 .. haystack.length - 1)
    {
        foreach(x; 1 .. haystack[y].length - 1)
        {
            if(haystack[y][x] == 'A')
            {
                string a = format!"%c%c%c"(
                        haystack[y - 1][x - 1],
                        haystack[y][x],
                        haystack[y + 1][x + 1],
                );
                string b = format!"%c%c%c"(
                        haystack[y - 1][x + 1],
                        haystack[y][x],
                        haystack[y + 1][x - 1],
                );
                occurrenceCount += (a == "MAS" || a == "SAM") && (b == "MAS" || b == "SAM");
            }
        }
    }
    return occurrenceCount;
}
