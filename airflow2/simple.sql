select* from player_scores
where score = (
select 
min(score)  as min_score
 from  player_scores)
union all
 select* from player_scores
where score = (
select 
Max(score)  as max_score
 from  player_scores)

