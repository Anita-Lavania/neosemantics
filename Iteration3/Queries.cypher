//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
// 1st order search

OPTIONAL MATCH p0 = (en0:Entity {{name: '{search_query}'}})<-[r1:HAS_ENTITY]-(a:Asset) 
WITH toInteger(r1.weight) AS Importance, a
WHERE Importance>=5 
RETURN DISTINCT a.name AS `Asset`, Importance
ORDER BY Importance DESC
LIMIT 5

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
// 2nd order search (pathlength =2) 

MATCH p0 = (en0:Entity {name: 'Devops'})-[r1]-(en1:Resource)<-[r2:HAS_ENTITY]-(a:Asset) 
WHERE en1.embeddings IS NOT NULL
WITH toInteger(r2.weight) AS Importance, r1, r2, a, en1, gds.similarity.cosine(en0.embeddings, en1.embeddings) AS sim_score
WHERE Importance>=5 AND r1.pcode<>'P1889' AND r1.pcode<>'P461' AND sim_score>0.05
RETURN a.name AS `Asset`, collect(Importance) AS Importance, collect(sim_score) AS sim_score, collect(en1.name) AS Entity1, collect(r1.name) AS Relationship1
ORDER BY Importance DESC
LIMIT 5
