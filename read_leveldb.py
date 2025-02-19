import leveldb

db = leveldb.LevelDB('blocks_leveldb')

key = "16338"  # 
value = db.Get(key.encode()).decode()

print("🔹 blocks:", value)
