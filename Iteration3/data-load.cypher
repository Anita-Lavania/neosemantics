// uniqueness constraint on :Resource
CREATE CONSTRAINT n10s_unique_uri ON (r:Resource) ASSERT r.uri IS UNIQUE;

// Set Graph configuration to 'Map'
CALL n10s.graphconfig.init({handleVocabUris: "MAP"});

// Load wikidata+wikipedia triples
CALL n10s.rdf.import.fetch("https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/Iteration3/wikidata_wikipedia.ttl","Turtle");


// Load Cognition triples
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/Iteration3/48cogdoc_rebel_triples_ww_weight.csv' AS row
WITH row.asset_name AS asset_name, row.source_uri AS source_uri, row.source_name AS source_name, row.edge_pcode AS edge_pcode, row.edge_name AS edge_name, row.target_uri AS target_uri, row.target_name AS target_name, row.source_weight AS source_weight, row.target_weight AS target_weight
MERGE (se:Resource {uri: source_uri})
    SET se:Entity
    SET se.name = source_name
MERGE (te:Resource {uri: target_uri})
    SET te:Entity
    SET te.name = target_name
MERGE (se)-[r:RELATED {name: edge_name}]->(te)
    SET r.pcode = edge_pcode
MERGE (a:Asset {name: asset_name})
MERGE (a)-[sr:HAS_ENTITY]->(se)
    SET sr.weight=source_weight
MERGE (a)-[tr:HAS_ENTITY]->(te)
    SET tr.weight=target_weight ;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/Iteration3/48cogdoc_rebel_triples_wm_weight.csv' AS row
WITH row.asset_name AS asset_name, row.source_uri AS source_uri, row.source_name AS source_name, row.edge_pcode AS edge_pcode, row.edge_name AS edge_name, row.target_uri AS target_uri, row.target_name AS target_name, row.source_weight AS source_weight, row.target_weight AS target_weight
MERGE (se:Resource {uri: source_uri})
    SET se:Entity
    SET se.name = source_name
MERGE (te:Resource {uri: target_uri})
    SET te:Entity:MathcoEntity
    SET te.name = target_name
MERGE (se)-[r:RELATED {name: edge_name}]->(te)
    SET r.pcode = edge_pcode
MERGE (a:Asset {name: asset_name})
MERGE (a)-[sr:HAS_ENTITY]->(se)
    SET sr.weight=source_weight
MERGE (a)-[tr:HAS_ENTITY]->(te)
    SET tr.weight=target_weight ;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/Iteration3/48cogdoc_rebel_triples_mw_weight.csv' AS row
WITH row.asset_name AS asset_name, row.source_uri AS source_uri, row.source_name AS source_name, row.edge_pcode AS edge_pcode, row.edge_name AS edge_name, row.target_uri AS target_uri, row.target_name AS target_name, row.source_weight AS source_weight, row.target_weight AS target_weight
MERGE (se:Resource {uri: source_uri})
    SET se:Entity:MathcoEntity
    SET se.name = source_name
MERGE (te:Resource {uri: target_uri})
    SET te:Entity
    SET te.name = target_name
MERGE (se)-[r:RELATED {name: edge_name}]->(te)
    SET r.pcode = edge_pcode
MERGE (a:Asset {name: asset_name})
MERGE (a)-[sr:HAS_ENTITY]->(se)
    SET sr.weight=source_weight
MERGE (a)-[tr:HAS_ENTITY]->(te)
    SET tr.weight=target_weight ;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/Iteration3/48cogdoc_rebel_triples_mm_weight.csv' AS row
WITH row.asset_name AS asset_name, row.source_uri AS source_uri, row.source_name AS source_name, row.edge_pcode AS edge_pcode, row.edge_name AS edge_name, row.target_uri AS target_uri, row.target_name AS target_name, row.source_weight AS source_weight, row.target_weight AS target_weight
MERGE (se:Resource {uri: source_uri})
    SET se:Entity:MathcoEntity
    SET se.name = source_name
MERGE (te:Resource {uri: target_uri})
    SET te:Entity:MathcoEntity
    SET te.name = target_name
MERGE (se)-[r:RELATED {name: edge_name}]->(te)
    SET r.pcode = edge_pcode
MERGE (a:Asset {name: asset_name})
MERGE (a)-[sr:HAS_ENTITY]->(se)
    SET sr.weight=source_weight
MERGE (a)-[tr:HAS_ENTITY]->(te)
    SET tr.weight=target_weight ;

// Load weights embeddings on cognition nodes
CALL apoc.load.json('https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/Iteration3/cognition_entity_embed.json') YIELD value AS row
WITH row.uri AS row_uri, row.name AS name, row.vector AS row_vector
MATCH (r:Resource {uri: row_uri})
    SET r.embeddings=row_vector ;
    

// Load Asset metadata
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/Iteration3/processed-asset-metadata.csv' AS row
WITH row.Id AS Id, row.Name AS Name, row.Owner AS Owner, row.Uploaded_Date AS Uploaded_Date, row.Updated_Date AS Updated_Date, row.Email AS Email, row.Account AS Account, row.Asset_Type AS Asset_Type
MATCH (a:Asset {name: Name})
    SET a.ID=Id, a.upload_date=Uploaded_Date, a.update_date=Updated_Date
MERGE (o:Author {email: Email})
    SET o.name=Owner
MERGE (acc:Account {name: Account})
MERGE (ast:AssetType {name: Asset_Type})
MERGE (a)-[:FOR_ACCOUNT]->(acc)
MERGE (a)-[:TYPE]->(ast)
