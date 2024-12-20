import std;

void main()
{
    string[] patterns = readln().strip().split(", ");
    readln();

    stdin.byLine.map!strip.map!idup.map!(design => isPossible(design, patterns)).sum().writeln();
}

alias fastIsPossible = memoize!isPossible;
ulong isPossible(string design, bool[string] patterns)
{
    ulong count;
    if(design in patterns)
    {
        count++;
    }

    foreach(i; iota(0, design.length))
    {
        if(design[0 .. i] in patterns)
        {
            count += fastIsPossible(design[i .. $], patterns);
        }
    }

    return count;
}

bool[string] mappify(string[] patterns)
{
    bool[string] patternSet;
    foreach(pattern; patterns)
    {
        patternSet[pattern] = true;
    }
    return patternSet;
}

ulong isPossible(string design, string[] patterns)
{
    return isPossible(design, patterns.mappify);
}
