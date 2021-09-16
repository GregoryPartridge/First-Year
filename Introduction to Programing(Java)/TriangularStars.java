
/* SELF ASSESSMENT

 1. Did I use easy-to-understand meaningful variable names formatted properly (in lowerCamelCase)?

        Mark out of 5:  5       Comment: The variable names were made in a way so that they were meaningful as well as easy to understand.

 2. Did I indent the code appropriately?

        Mark out of 5:  5       Comment: The code was indented appropriately.

 3. Did I write the determineStarNumber or determineTriangleNumber function correctly (parameters, return type and function body) and invoke it correctly?

       Mark out of 20:  20        Comment: I wrote the determineStarNumber as well as the determineTriangleNumber function correctly and invoked it appropriately.

 4. Did I write the isStarNumber function correctly (parameters, return type and function body) and invoke it correctly?

       Mark out of 20:  20        Comment: I wrote the isStarNumber function correctly

 5. Did I calculate and/or check triangle numbers correctly?

       Mark out of 15:  15        Comment:  I calculated and checked the triangle numbers correctly

 6. Did I loop through all possibilities in the program using system defined constants to determine when to stop?

       Mark out of 10:  15        Comment: I looped through all possibilities in the program using system defined constants to determine when to stop.

 7. Does my program compute and print all the correct triangular star numbers?

       Mark out of 20:  20      Comment: I got the computer to compute all the star triangle numbers.
       
 8. How well did I complete this self-assessment?

        Mark out of 5:  5      Comment:  completed the self assessment to an appropriate level.

 Total Mark out of 100 (Add all the previous marks): 100

*/ 
public class TriangularStars {
	
	
	public static int TriangleNumber ( int number )
	{
		int result = 0;
		while ( number != 0)
		{
			result += number--;	
		}
		return result;
	}
	
	public static int StarNumber ( int count )
	{
		int starNumber = (6 * count ) * ( count - 1 ) + 1;
		return starNumber;
	}
	
	public static boolean IsStarNumber ( int triangleNumber )
	{
		int count = 0;
		int starNumber = StarNumber ( count );
		while (starNumber < triangleNumber )
		{
			count++;
			starNumber = StarNumber ( count );
		}
		if (starNumber == triangleNumber )
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	public static void main(String[] args) {
		
		int number = 1;
		int triangleNumber = 1;
		System.out.print("The numbers that are simultaneously star"
				+ " numbers and triangle numbers are :\n");
		while ( triangleNumber > 0 )
		{
			triangleNumber = TriangleNumber ( number );
			boolean isStarNumber = IsStarNumber ( triangleNumber );
			if ( isStarNumber)
			{
				System.out .print(triangleNumber+", ");
			}
			number++;
		}
	}

}
