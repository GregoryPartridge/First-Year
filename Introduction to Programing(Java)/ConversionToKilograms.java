package eTest;

import java.util.Scanner;


public class ConversionToKilograms {

	public static final double KILOGRAMS_IN_AN_OUNCE = 0.02834952;
	public static final double OUNCES_IN_A_POUND = 16;
	public static final double POUNDS_IN_A_STONE = 14;

	public static void main(String[] args) {
		
		Scanner input = new Scanner ( System.in );
		boolean finished = false;
		
		while ( !finished)
		{
		System.out.println("Enter the number of Stones, Pounds and Ounces seperated by spaces (or enter 'quit'):");
	
		if (input.hasNext("quit"))
		{
			finished = true;
		}
		else
		{
			input.useDelimiter(" |r\n");
			int stones = input.nextInt();
			int pounds = input.nextInt();
			int ounces = input.nextInt();
			
			System.out.println(stones+" stones, "+pounds+" pounds, "+ounces+" ounces is equal to kg");
			
			double kilograms = convertToKilograms ( stones, pounds, ounces);
			getFormatedWeightString ( stones, pounds, ounces, kilograms);
			
			String amountOfKilograms = getFormatedWeightString ( stones, pounds, ounces, kilograms);
			System.out.println( amountOfKilograms );
		}
		}
		input.close();
	}
	
	public static double convertToKilograms ( int stones, int pounds, int ounces )
	{
		double numberOfPounds = (stones * POUNDS_IN_A_STONE) + pounds;
		double numberOfOunces = (numberOfPounds * OUNCES_IN_A_POUND) + ounces;
		double numberOfKilograms = numberOfOunces * KILOGRAMS_IN_AN_OUNCE;
		return numberOfKilograms;
		
		
	}
	
	public static String getFormatedWeightString ( int stones, int pounds, int ounces, double kilograms)
	{
		boolean printStones = false;
		boolean printPounds = false;
		boolean printOunces = false;
		
		
		if ( stones > 0)
		{
			printStones = true;
		}
		if ( pounds > 0)
		{
			printPounds = true;
		}
		if ( ounces > 0)
		{
			printOunces = true;
		}
		
		if ( !printOunces)
		{
			if ( !printPounds)
			{
				if ( !printStones )
				{
					printOunces = true;
				}
			}
		}
		
	String amountOfKilograms = 	"";
	
	if ( printStones)
	{
		amountOfKilograms += stones;
		switch ( stones)
		{
		case 1:
			amountOfKilograms += " stone";
			break;
		default:
			amountOfKilograms += " stones";
			break;
		}
		}
	if ( printPounds)
	{
		if (printStones)
		{
			amountOfKilograms += ", ";
		}	
		
		amountOfKilograms += stones;
		switch ( stones)
		{
		case 1:
			amountOfKilograms += " pound";
			break;
		default:
			amountOfKilograms += " pounds";
			break;
		}
		}
	if ( printOunces)
	{
		if (printStones)
		{
			amountOfKilograms += ", ";
		}
		if (printPounds)
		{
			amountOfKilograms += ", ";
		}
		
		
		amountOfKilograms += stones;
		switch ( stones)
		{
		case 1:
			amountOfKilograms += " ounce";
			break;
		default:
			amountOfKilograms += " ounces";
			break;
		}
		}
	
	amountOfKilograms += " is equal to "+kilograms+"kg";
	return amountOfKilograms;
	}
	
		
	}
	

