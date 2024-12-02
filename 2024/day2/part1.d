import std;

void main()
{
    int result;
    foreach(line; stdin.byLine)
    {
        result += line.strip.split(" ").map!(to!int).array.isSafe();
    }
    result.writeln();
}

bool isSafe(int[] levels)
{
    if(!levels.isSorted && !levels.retro.isSorted)
    {
        return false;
    }
    foreach(pair; levels.slide(2))
    {
        if(abs(pair[0] - pair[1]) < 1 || abs(pair[0] - pair[1]) > 3)
        {
            return false;
        }
    }
    return true;
}
