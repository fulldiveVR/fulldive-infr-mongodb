import { expect } from "chai"
import { MongoDbIgniter } from "../lib"

describe("Test MongoDbIgniter", async () => {
    it("Test init db", async () => {
        const collectionName = "test"
        const dbName = "fulldive-infr-mongodb-test"
        const config = {
            connectionString: "mongodb://localhost",
            dbName: dbName,
            collections: [
                {
                    name: collectionName,
                    indexes: [
                            {
                                keys: {
                                    name: 1,
                                },
                                options: {
                                    unique: true,
                                    background: false
                                }
                            }
                        ]
                }
            ]
        }
        const db = await MongoDbIgniter.initializeDb(config)
        const collection = db.collection(collectionName)
        const name = "FullDive"
        await collection.deleteOne({ name })
        await collection.insertOne({ name })
        const expectElement = await collection.findOne({ name })
        expect(collection.dbName).eq(dbName)
        expect(collection.collectionName).eq(collectionName)
        expect(expectElement.name).eq(name)
    })
})