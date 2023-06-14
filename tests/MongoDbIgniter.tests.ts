import { expect } from "chai"
import { MongoDbIgniter } from "../src/mongodb-igniter/MongoDbIgniter"

describe("Test MongoDbIgniter", async () => {
    it("Test init db", async () => {
        const collectionName = "test"
        const dbName = "fulldive-infr-mongodb-test"
        const config = {
            connectionString: "mongodb://localhost",
            dbName: dbName,
            collections: [
                {
                    name: collectionName
                }
            ]
        }
        const db = await MongoDbIgniter.initializeDb(config)
        const collection = db.collection(collectionName)
        expect(collection.dbName).eq(dbName)
        expect(collection.collectionName).eq(collectionName)
    })
})