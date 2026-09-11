                  

                                                         
                                                         

                                                                        

                                                                                                               
 
                                                                 
                                                                                                
                               

                                                       
  
                           
                               
                     

                                         
                                                                                                         
                                     
  
 

                                                                                                            
 
                                                                   

                                           

                                          
                                         
                                         
                                           
                                 
                                                     
                                                         
                                                 
                                        
                                            
                                                            

            
  
            
                                                                              
                               
       
                                               
                                         
        
  

           
                                    
                                                                                  
                                                                   
                                                       
       
 

                                                                                                                                                                       
 
                                    
                                                                                     
                                                                                    
                   
          
  
                        
  
            
                  
                  
                 
  

                                                                 

                       
          


           
                                               
   
                                                                                             
                                                                                               
                                                                            
                                                                
   
      
   
                                                                         
                                                                            
                                                                

   


                                   
                                    
       

           
                                                                                           
       
                                     
  
 
                           

global function OnWeaponPrimaryAttack_weapon_creaturebait
global function OnProjectileCollision_weapon_creaturebait

var function OnWeaponPrimaryAttack_weapon_creaturebait( entity weapon, WeaponPrimaryAttackParams attackParams ) // these are needed for weapons stuff
{
}
#if SERVER
void function OnProjectileCollision_weapon_creaturebait( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
#else
void function OnProjectileCollision_weapon_creaturebait( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
#endif
{
	projectile.SetVelocity( <0, 0, 0> )
}
                                     
