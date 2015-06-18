
import java.util.ArrayList;
import java.util.*;
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author poonambhide
 */
class ValueGenerator {
    double upperlimit,base;

    
    List<Integer> getHighestbasenumbers(){
    
            List<Integer> ints = new ArrayList<Integer>();
            for(int i=0;i<=upperlimit;i++)
            {
                int num=(int)Math.pow(base,i);
                if((int)Math.pow(base,i)<=upperlimit)
                {
                    ints.add(new Integer(num));
                    System.out.println(i + " : " + ints.get(i));
                }
                else
                    break;
                    
            }
                
            return ints;
    
    }

    void GenerateNumbers()
    {
        List<Integer> ints=getHighestbasenumbers();
        HashMap<Integer, ArrayList<Integer>> hashmap = new HashMap<Integer, ArrayList<Integer>>();
        
        int maxsize=ints.size()-1;

        for(int i=1;i<=upperlimit;i++)   
        {
            maxsize=ints.size()-1;
            System.out.println("\n");
            int j=i;
            while(j!=0 && (maxsize!=-1))  
            {
                if(j>=ints.get(maxsize) )
                {
                   ArrayList<Integer> arr=new ArrayList<Integer>();

                   if(hashmap.containsKey(ints.get(maxsize)))  
                     arr= hashmap.get(ints.get(maxsize));                               
                   else                      
                     hashmap.put(new Integer(ints.get(maxsize)),arr);
                    arr.add(i);
                    hashmap.put(new Integer(ints.get(maxsize)),arr);
                    System.out.print(" " + j + ":" + ints.get(maxsize) + " ");
                    j=j-ints.get(maxsize);
                }                                  
                maxsize--;  

             }         
        }
        System.out.println("\n");
        System.out.println(hashmap);
    }
    ValueGenerator(int ul,int b)
    {
        upperlimit=ul;
        base=b;
    }
    
}
public class PuzzleNumber {
    
    public static void main(String[] args) {
        
        ValueGenerator val=new ValueGenerator(100,2);
        val.GenerateNumbers();
    
    }
    
}
