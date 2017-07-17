#!/usr/bin/python3
import os
import re
import subprocess as sub


def parseTags(explFile):
    content = open(explFile, 'r').read()
    tags = re.findall('\|[^\|]+\|', content)
    return tags


def parseBookmarks(explFile):
    content = open(explFile, 'r').read().split('\n')
    isBookmark = False
    bookmarkList = []
    bookmark = ''
    for line in content:

        #  Beging of a bookmark
        if re.match('^- .', line):
            isBookmark = True

        # Read the bookmark
        if isBookmark:
            bookmark += line + '\n'

        # Detect the end of the bookmark
        if re.match('^\s*$', line) and isBookmark:
            isBookmark = False
            bookmarkList.append(bookmark)
            bookmark = ''

    return bookmarkList


def main():
    LOCALPATH = os.path.expanduser('~/NavigationLog')
    BOOKMARKPATH = os.path.join(LOCALPATH, 'BOOKMARKS')
    TAGSPATH = os.path.join(LOCALPATH, 'TAGS')
    FINDOUT = sub.getoutput('find {0} -iname "*.expl"'.format(LOCALPATH))
    FILELIST = FINDOUT.split('\n')

    # Parse all the expl files
    tags = []
    bookmarks = []
    for f in FILELIST:
        tags += parseTags(f)
        bookmarks += parseBookmarks(f)
    tags = sorted(list(set(tags)))

    # Overwrite the TAGS and BOOKMARKS files
    f_tags = open(BOOKMARKPATH, 'w')
    f_tags.write(''.join(bookmarks))
    f_tags.close()
    f_bm = open(TAGSPATH, 'w')
    f_bm.write('\n'.join(tags))
    f_bm.close()


if __name__ == '__main__':
    main()
