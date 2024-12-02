import std;

void main()
{
    int result;
    foreach(line; stdin.byLine)
    {
        result += line.strip.split(" ").map!(to!int).array.isSafeish();
    }
    result.writeln();
}

bool isSafeish(int[] levels)
{
    foreach(i; iota(0, levels.length))
    {
        if(isSafe(levels[0 .. i] ~ levels[i + 1 .. $]))
        {
            return true;
        }
    }
    return false;
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
