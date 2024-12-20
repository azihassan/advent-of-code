import std;

void main()
{
    string[] patterns = readln().strip().split(", ");
    readln();

    stdin.byLine.map!strip.map!idup.count!(design => isPossible(design, patterns)).writeln();
}

alias fastIsPossible = memoize!isPossible;
bool isPossible(string design, bool[string] patterns)
{
    if(design in patterns)
    {
        return true;
    }

    foreach(i; iota(0, design.length))
    {
        if(design[0 .. i] in patterns)
        {
            if(fastIsPossible(design[i .. $], patterns))
            {
                return true;
            }
        }
    }

    return false;
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

bool isPossible(string design, string[] patterns)
{
    return isPossible(design, patterns.mappify);
}
