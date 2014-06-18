#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os.path


class PinYin(object):
    def __init__(self, dict_file='util/word.data'):
        self.word_dict = {}
        self.dict_file = dict_file


    def __load_word__(self):
        if not os.path.exists(self.dict_file):
            raise IOError("NotFoundFile")

        with file(self.dict_file) as f_obj:
            for f_line in f_obj.readlines():
                try:
                    line = f_line.split('    ')
                    self.word_dict[line[0]] = line[1]
                except:
                    line = f_line.split('   ')
                    self.word_dict[line[0]] = line[1]


    def hanzi2pinyin(self, string=""):
        self.__load_word__()
        result = []
        specificCities = self.getSpecificCities()
        if specificCities.has_key(string):
            return specificCities[string]
        if not isinstance(string, unicode):
            string = string.decode("utf-8")
        
        for char in string:
            key = '%X' % ord(char)
            result.append(self.word_dict.get(key, char).split()[0][:-1].lower())

        return result


    def hanzi2pinyin_split(self, string="", split=""):
        result = self.hanzi2pinyin(string=string)
        return split.join(result)

    def getSpecificCities(self):
        return {
            "重庆": ["chong","qing"],
            "忻州": ["xin","zhou"],
            "沈阳": ["shen","yang"],
            "抚顺": ["fu","shun"],
            "朝阳": ["chao","yang"],
            "蚌埠": ["beng","bu"],
            "厦门": ["xia","men"],
            "莆田": ["pu","tian"],
            "莱芜": ["lai","wu"],
            "漯河": ["luo","he"]
        }


if __name__ == "__main__":
    test = PinYin("word.data")
    string = "沈阳"
    print "in: %s" % string
    print "out: %s" % str(test.hanzi2pinyin(string=string))
    print "out: %s" % test.hanzi2pinyin_split(string=string)