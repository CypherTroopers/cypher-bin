import json
import leveldb

db = leveldb.LevelDB('blocks_leveldb')

with open('blocks.json', 'r') as f:
    for line in f:
        block = json.loads(line)
        key = str(block['number'])  
        value = json.dumps(block)   
        db.Put(key.encode(), value.encode())

print("✅ LevelDB DONE")
