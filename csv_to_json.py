import csv
import json

csv_file = "blocks.csv"
json_file = "blocks.json"

with open(csv_file, "r") as f:
    reader = csv.DictReader(f)
    
    with open(json_file, "w") as j:
        for row in reader:
            row["number"] = int(row["number"])
            json.dump(row, j)
            j.write("\n")  

print("✅ CSV to JSON DONE")
