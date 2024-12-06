import std;

void main()
{
    int[2][] precedence;
    int[][int] precedenceMap;
    foreach(line; stdin.byLine.map!idup.map!strip)
    {
        if(line.length == 0)
        {
            break;
        }
        int[2] rule;
        line.formattedRead!"%d|%d"(rule[0], rule[1]);
        precedenceMap[rule[0]] ~= rule[1];
        precedence ~= rule;
    }

    int result;
    foreach(line; stdin.byLine.map!idup.map!strip)
    {
        int[] pages = line.splitter(",").map!(to!int).array();
        if(pages.isOrdered(precedenceMap))
        {
            continue;
        }
        pages.rearrange(pages.countChildren(precedence));
        result += pages[$ / 2];
    }
    result.writeln();
}

int[int] countChildren(int[] pages, int[2][] precedence)
{
    int[int] counts;
    foreach(rule; precedence)
    {
        if(!pages.canFind(rule[0]) || !pages.canFind(rule[1]))
        {
            continue;
        }
        counts[rule[0]]++;
    }
    return counts;
}

int[] rearrange(int[] pages, int[int] precedenceCounts)
{
    foreach(page; pages)
    {
        if(page !in precedenceCounts)
        {
            precedenceCounts[page] = 0;
        }
    }
    pages.sort!((a, b) => precedenceCounts[a] > precedenceCounts[b]);
    return pages;
}

bool isOrdered(int[] pages, int[][int] precedenceMap)
{
    foreach(i, page; pages)
    {
        if(pages[i + 1 .. $].any!(otherPage => otherPage in precedenceMap && precedenceMap[otherPage].canFind(page)))
        {
            return false;
        }
    }
    return true;
}
