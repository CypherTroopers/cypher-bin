import leveldb

db = leveldb.LevelDB('blocks_leveldb')

print("🔹 LevelDB key list:")
for key, _ in db.RangeIter():
    print("key:", key.decode())
