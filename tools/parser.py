import json
import xmltodict
kanji_reading = []
jlpt_list = []
jlpt_list.append([])
jlpt_list.append([])
jlpt_list.append([])
jlpt_list.append([])
jlpt_list.append([])
with open("JMdict_e.json", encoding="utf8") as f:
    data = json.load(f)
    for entry in data:
        try:
            kanji = entry["k_ele"][0]["keb"]#["keb"]
            readings = []
            reading_list = entry["r_ele"]
            for reading in reading_list:
                readings.append(reading["reb"])
            #print((kanji, readings))
            kanji_reading.append([kanji, readings, -1])
        except:
            pass


with open("kanjidic2.json", encoding="utf8") as f:
    data = json.load(f)
    for entry in data:
        #print(entry.keys())
        try:
            jlpt_list[entry["jlpt"]].append(entry["literal"])
            #print(entry["jlpt"])
        except:
            pass
    #print(jlpt_list)

N5 = []
n5 = False
N4 = []
n4 = False
N3 = []
n3 = False
N2 = []
n2 = False
N1 = []
n1 = False
with open("kanji.txt", encoding="utf8") as f:
    for i in f.readlines():
        i = i[:-1]
        if i == "N5":
            #print("LoL")
            n5 = True
        elif i == "N4":
            n5 = False
            n4 = True
        elif i == "N3":
            n4 = False
            n3 = True
        elif i == "N2":
            n3 = False
            n2 = True 
        elif i == "N1":
            n2 = False
            n1 = True
        else:
            if(n5):
                if(i != ""):
                    N5.append(i)
            elif(n4):
                if(i != ""):
                    N4.append(i)
            elif(n3):
                if(i != ""):
                    N3.append(i)
            elif(n2):
                if(i != ""):
                    N2.append(i)
            elif(n1):
                if(i != ""):
                    N1.append(i)

print("N5 " + str(len(N5)))
print("N5 " + str(len(jlpt_list[4])))
print("N4 " + str(len(N4)))
print("N4 " + str(len(jlpt_list[3])))
print("N3 " + str(len(N3)))
print("N3 " + str(len(jlpt_list[2])))
print("N2 " + str(len(N2)))
print("N2 " + str(len(jlpt_list[1])))
print("N1 " + str(len(N1)))
print("N1 " + str(len(jlpt_list[0])))

def Diff(li1, li2):
    return list(set(li1) - set(li2)) + list(set(li2) - set(li1))

N1 = jlpt_list[1]
N2 = Diff(jlpt_list[2], N3)

import csv
with open("Kanji_withJLPT.csv", "w", newline="", encoding="utf8") as csvfile:
    writer = csv.writer(csvfile, delimiter=",")
    writer.writerow(N5)
    writer.writerow(N4)
    writer.writerow(N3)
    writer.writerow(N2)
    writer.writerow(N1)