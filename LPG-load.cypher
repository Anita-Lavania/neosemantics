CREATE CONSTRAINT n10s_unique_uri ON (r:Resource) ASSERT r.uri IS UNIQUE;

CALL n10s.graphconfig.init({handleVocabUris: "MAP"});


CALL n10s.rdf.import.fetch("https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/wikidata_wikipedia.ttl","Turtle");

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/20cogdoc_rebel_triples_ww.csv' AS row
WITH row.asset_name AS asset_name, row.source_uri AS source_uri, row.source_name AS source_name, row.edge_pcode AS edge_pcode, row.edge_name AS edge_name, row.target_uri AS target_uri, row.target_name AS target_name
MERGE (se:Resource {uri: source_uri})
    SET se.name = source_name
MERGE (te:Resource {uri: target_uri})
    SET te.name = target_name
MERGE (se)-[r:RELATED {name: edge_name}]->(te)
    SET r.pcode = edge_pcode
MERGE (a:Asset {name: asset_name})
MERGE (a)-[:HAS_ENTITY]->(se)
MERGE (a)-[:HAS_ENTITY]->(te)

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/20cogdoc_rebel_triples_wm.csv' AS row
WITH row.asset_name AS asset_name, row.source_uri AS source_uri, row.source_name AS source_name, row.edge_pcode AS edge_pcode, row.edge_name AS edge_name, row.target_uri AS target_uri, row.target_name AS target_name
MERGE (se:Resource {uri: source_uri})
    SET se.name = source_name
MERGE (te:Entity {uri: target_uri})
    SET te.name = target_name
MERGE (se)-[r:RELATED {name: edge_name}]->(te)
    SET r.pcode = edge_pcode
MERGE (a:Asset {name: asset_name})
MERGE (a)-[:HAS_ENTITY]->(se)
MERGE (a)-[:HAS_ENTITY]->(te)

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/20cogdoc_rebel_triples_mw.csv' AS row
WITH row.asset_name AS asset_name, row.source_uri AS source_uri, row.source_name AS source_name, row.edge_pcode AS edge_pcode, row.edge_name AS edge_name, row.target_uri AS target_uri, row.target_name AS target_name
MERGE (se:Entity {uri: source_uri})
    SET se.name = source_name
MERGE (te:Resource {uri: target_uri})
    SET te.name = target_name
MERGE (se)-[r:RELATED {name: edge_name}]->(te)
    SET r.pcode = edge_pcode
MERGE (a:Asset {name: asset_name})
MERGE (a)-[:HAS_ENTITY]->(se)
MERGE (a)-[:HAS_ENTITY]->(te)

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Anita-Lavania/neosemantics/main/20cogdoc_rebel_triples_mm.csv' AS row
WITH row.asset_name AS asset_name, row.source_uri AS source_uri, row.source_name AS source_name, row.edge_pcode AS edge_pcode, row.edge_name AS edge_name, row.target_uri AS target_uri, row.target_name AS target_name
MERGE (se:Entity {uri: source_uri})
    SET se.name = source_name
MERGE (te:Entity {uri: target_uri})
    SET te.name = target_name
MERGE (se)-[r:RELATED {name: edge_name}]->(te)
    SET r.pcode = edge_pcode
MERGE (a:Asset {name: asset_name})
MERGE (a)-[:HAS_ENTITY]->(se)
MERGE (a)-[:HAS_ENTITY]->(te)
