#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <conio.h>
#include <cstdio>
#include <time.h>
using namespace std;
int Menu();
int Choose_create();
void Create(int**);
int Output(int**,int**,int&,int&);
int My_Shot(int**,int&, int&);
bool Check_kill(int**, int&, int&,int);
bool Check_win(int**);
void Op_shot(int**);
void Saving(int **, int **,FILE*,int&);
void Upload(int**, int**,FILE*,int&);
void Self_create(int**);
int Choose_difficult();
void Medium_shot(int**,int&,int&,bool&);
void Hard_shot(int**);
int main()
{
	bool medium_mem1 = false;
	bool&medium_mem = medium_mem1;
	int medium_a1 = 0, medium_b1 = 0;
	int& medium_a = medium_a1;
	int &medium_b = medium_b1;
	srand(time(NULL));
	int answer = Menu();
	FILE*f = fopen("SeaFight.txt", "r+");
	int**My = new int*[10];
	for (int i = 0; i < 10; i++)
		My[i] = new int[10];
	for (int i = 0; i < 10; i++)
		for (int j = 0; j < 10; j++)
			My[i][j] = 0;
	int**Op = new int*[10];
	for (int i = 0; i < 10; i++)
		Op[i] = new int[10];
	for (int i = 0; i < 10; i++)
		for (int j = 0; j < 10; j++)
			Op[i][j] = 0;
	int difficult1 = 0;
	int &difficult = difficult1;
	switch (answer)
	{
	case 0:
		f = freopen("SeaFight.txt", "w",f);
		if (Choose_create() == 0)
			Self_create(My);
		else
			Create(My);
		Create(Op);
		difficult=Choose_difficult();
		break;
	case 1:
		if (f == NULL)
		{
			cout << "Missing file. You will start a new game\n";
			f = fopen("SeaFight.txt", "w");
			Create(My);
			Create(Op);
			system("pause");
			break;
		}
		Upload(My, Op, f,difficult);
		break;
	}
	int key1 = 0;
	int &key = key1;
	int key3 = 0;
	int &key2 = key3;
	bool win = false;
	for (;!win;)
	{
		if(Output(My,Op,key,key2)==2)
		{
			Saving(My, Op, f,difficult);
			break;
		}
		if(My_Shot(Op, key, key2)==1)
			continue;
		win=Check_win(Op);
		if (win)
		{
			system("cls");
			cout << "\n\n\n\n\n\n\n\nYou win!!!\n\n\n\n\n\n\n\n";
			break;
		}
		if(difficult==0)Op_shot(My);
		if (difficult == 1)Medium_shot(My, medium_a, medium_b, medium_mem);
		if (difficult == 2)Hard_shot(My);
		win = Check_win(My);
		if (win)
		{
			system("cls");
			cout << "\n\n\n\n\n\n\n\nYou lose:(\n\n\n\n\n\n\n\n";
			break;
		}
	}
	for (int i = 0; i < 10; i++)
		delete []My[i];
	delete []My;
	for (int i = 0; i < 10; i++)
		delete []Op[i];
	delete []Op;
	fclose(f);
	return 0;
}
int Menu()
{
	int key = 0;
	int code=0;
	for (; code != 13;)
	{
		system("cls");
		if (key % 2 == 0)
			cout << ">New game\t<\n";
		else
			cout << "New game\n";
		if (key % 2 != 0)
			cout << ">Continue game\t<\n";
		else
			cout << "Continue game\n";
		code=_getch();
		if (code == 13)
			break;
		code = _getch();
		if (code == 80)
			key=1;
		if (code == 72)
			key=0;
	}
	return key;
}
int Choose_create()
{
	int key = 0;
	int code = 0;
	for (; code != 13;)
	{
		system("cls");
		if (key % 2 == 0)
			cout << ">Place ships by yourself\t<\n";
		else
			cout << "Place ships by yourself\n";
		if (key % 2 != 0)
			cout << ">Autoplacing\t<\n";
		else
			cout << "Autoplacing\n";
		code = _getch();
		if (code == 13)
			break;
		code = _getch();
		if (code == 80)
			key = 1;
		if (code == 72)
			key = 0;
	}
	return key;
}
void Create(int**My)
{
	for (;;)//4444444444444444444444444444444444444444444444444
	{
		int a = rand() % 7;
		int b = rand() % 7;
		int c = rand() % 2;
		if (c == 0)
		{
			My[a][b] = 4;
			My[a][b + 1] = 4;
			My[a][b + 2] = 4;
			My[a][b + 3] = 4;
			break;
		}
		if (c==1)
		{
			My[a][b] = 4;
			My[a+1][b] = 4;
			My[a+2][b] = 4;
			My[a+3][b] = 4;
			break;
		}
	}
	for (int i=0;;)//3333333333333333333333333333333333333333
	{
		int a = rand() % 8;
		int b = rand() % 8;
		int c = rand() % 2;
		bool t = true;
		if (!c)
		{
			for (int i = a - 1; i < a + 2; i++)
			{
				for (int j = b - 1; j < b + 4; j++)
				{
					if (i >= 0 && j >= 0 && i<10 && j<10)
					{
						if (My[i][j] == 4||My[i][j]==3)
						{
							t = false;
							break;
						}
					}
				}
				if (!t)break;
			}

			if (t)
			{
				My[a][b] = 3;
				My[a][b + 1] = 3;
				My[a][b + 2] = 3;
				i++;
				if (i == 2)
					break;
			}
		}
		if (c)
		{
			for (int i = a - 1; i < a + 4; i++)
			{
				for (int j = b - 1; j < b + 2; j++)
				{
					if (i >= 0 && j >= 0 && i<10 && j<10)
					{
						if (My[i][j] == 4 || My[i][j] == 3)
						{
							t = false;
							break;
						}
					}
		     	}
				if (!t)break;
			}

			if (t)
			{
				My[a][b] = 3;
				My[a + 1][b] = 3;
				My[a + 2][b] = 3;
				i++;
				if (i == 2)
					break;
			}
		}
	}
	for (int i = 0;;)//222222222222222222222222222222222222222
	{
		int a = rand() % 9;
		int b = rand() % 9;
		int c = rand() % 2;
		bool t = true;
		if (!c)
		{
			for (int i = a - 1; i < a + 2; i++)
			{
				for (int j = b - 1; j < b + 3; j++)
				{
					if (i >= 0 && j >= 0 && i<10 && j<10)
					{
						if (My[i][j] == 4 || My[i][j] == 3||My[i][j]==2)
						{
							t = false;
							break;
						}
					}
				}
				if (!t)break;
			}

			if (t)
			{
				My[a][b] = 2;
				My[a][b + 1] = 2;
				i++;
				if (i == 3)
					break;
			}
		}
		if (c)
		{
			for (int i = a - 1; i < a + 3; i++)
			{
				for (int j = b - 1; j < b + 2; j++)
				{
					if (i >= 0 && j >= 0&&i<10&&j<10)
					{
						if (My[i][j] == 4 || My[i][j] == 3||My[i][j]==2)
						{
							t = false;
							break;
						}
					}
				}
				if (!t)break;
			}

			if (t)
			{
				My[a][b] = 2;
				My[a + 1][b] = 2;
				i++;
				if (i == 3)
					break;
			}
		}
	}
	for (int i = 0;;) //111111111111111111111111111111111
	{
		int a = rand() % 10;
		int b = rand() % 10;
		bool t = true;
		for (int i = a - 1; i < a + 2; i++)
		{
			for (int j = b - 1; j < b + 2; j++)
			{
				if (i >= 0 && j >= 0 && i<10 && j<10)
				{
					if (My[i][j] == 4 || My[i][j] == 3 || My[i][j] == 2 || My[i][j]==1)
					{
						t = false;
						break;
					}
				}
			}
			if (!t)break;
		}
		if (t)
		{
			My[a][b] = 1;
			i++;
			if (i == 4)
				break;
		}
	}
}
int Output(int**My, int**Op,int&key,int&key2)
{
	int code = 0;
	char field[25] = { "  A.B.C.D.E.F.G.H.I.J" };
	for (; code != 13;)
	{
		system("cls");
		cout << "\nTo save game press \"S\"\n";
		cout << "\n"<< field <<"\n";
		for (int i = 0; i < 10; i++)
		{
			cout << i + 1;
			if (i < 9)
				cout << " ";
			for (int j = 0; j < 10; j++)
			{
				if (My[i][j] == 0)
					cout << "_|";
				if (My[i][j] == 1 || My[i][j] == 2 || My[i][j] == 3 || My[i][j] == 4)
					cout << "#|";
				if (My[i][j] == 5)
					cout << "o|";
				if (My[i][j] == 6 || My[i][j] == 7 || My[i][j] == 8 || My[i][j] == 13 || My[i][j] == 9)
					cout << "X|";
			}
			cout << endl;
		}
		cout << endl << field << "\n";
		for (int i = 0; i < 10; i++)
		{
			cout << i + 1;
			if (i < 9)
				cout << " ";
			for (int j = 0; j < 10; j++)
			{
				if ((i == key)&&(j == key2))
				{
					cout << "*|";
					continue;
				}
				if (Op[i][j] == 0|| Op[i][j] == 1|| Op[i][j] == 2 || Op[i][j] == 3 || Op[i][j] == 4)
					cout << "_|";
				if (Op[i][j] == 5)
					cout << "o|";
				if (Op[i][j] == 6||Op[i][j]==7 || Op[i][j] == 8 || Op[i][j] == 13|| Op[i][j] == 9)
					cout << "X|";
			}
			cout << endl;
		}
		code = _getch();
		if (code == 13)
			break;
		if (code == 115)
			return 2;
		code = _getch();
		if ((code == 80)&&(key<9))
			key++;
		if ((code == 72)&&(key>0))
			key--;
		if ((code==77)&&(key2<9))
			key2++;
		if ((code == 75) && (key2 > 0))
			key2--;
	}
	return 0;
}
int My_Shot(int**Op,int&key, int&key2)
{
	if (Op[key][key2] == 0)
	{
		cout << "\nMiss:(\n";
		Op[key][key2] = 5;
	}
	else if(Op[key][key2] == 1)
	{
		cout << "\nKill!\n";
		Op[key][key2] = 13;
		for (int i = key - 1; i < key + 2; i++)
		{
			for (int j = key2 - 1; j < key2 + 2; j++)
			{
				if (i >= 0 && j >= 0 && i < 10 && j < 10)
				{
					if (Op[i][j] != 13)
						Op[i][j] = 5;
				}
			}
		}
	}
	else if(Op[key][key2] == 2)
	{
		Op[key][key2] = 7;
		bool t = Check_kill(Op, key, key2, 2);
		if (t)
			cout << "\nKill!\n";
		else
		{
			cout << "\nHit!\n";
		}
	}
	else if (Op[key][key2] == 3)
	{
		Op[key][key2] = 8;
		bool t = Check_kill(Op, key, key2, 3);
		if (t)
			cout << "\nKill!\n";
		else
			cout << "\nHit!\n";
	}
	else if (Op[key][key2] == 4)
	{
		Op[key][key2] = 9;
		bool t = Check_kill(Op, key, key2, 4);
		if (t)
			cout << "\nKill!\n";
		else
			cout << "\nHit!\n";
	}
	else
	{
		cout << "\nYou have already shot here. Try again\n";
		system("pause");
		return 1;
	}
	system("pause");
	return 0;
}
bool Check_kill(int**Op, int&key, int&key2,int pos)
{
	bool t = false;
	switch (pos)
	{
	case 2:
		for (int i = 0; i < 9; i++)
		{
			if (Op[key][i] == 7 && Op[key][i + 1]==7)
			{
				Op[key][i] = 13;
				Op[key][i + 1] = 13;
				for (int k = key - 1; k < key + 2; k++)
				{
					for (int p = i - 1; p < i + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = key-1; k < key + 2; k++)
				{
					for (int p = i; p < i + 3; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				t = true;
				return t;
			}
		}
		for (int i = 0; i < 9; i++)
		{
			if (Op[i][key2] == 7 && Op[i+1][key2] == 7)
			{
				Op[i][key2] = 13;
				Op[i+1][key2] = 13;
				for (int k = i - 1; k < i + 2; k++)
				{
					for (int p = key2 - 1; p < key2 + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = i; k < i + 3; k++)
				{
					for (int p = key2 - 1; p < key2 + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				t = true;
				return t;
			}
		}
		break;
	case 3:
		for (int i = 0; i < 8; i++)
		{
			if (Op[key][i] == 8 && Op[key][i + 1] == 8 && Op[key][i + 2] == 8)
			{
				Op[key][i] = 13;
				Op[key][i + 1] = 13;
				Op[key][i + 2] = 13;
				for (int k = key - 1; k < key + 2; k++)
				{
					for (int p = i - 1; p < i + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = key - 1; k < key + 2; k++)
				{
					for (int p = i; p < i + 3; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = key - 1; k < key + 2; k++)
				{
					for (int p = i + 1; p < i + 4; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				t = true;
				return t;
			}
		}
		for (int i = 0; i < 8; i++)
		{
			if (Op[i][key2] == 8 && Op[i + 1][key2] == 8&&Op[i+2][key2]==8)
			{
				Op[i][key2] = 13;
				Op[i + 1][key2] = 13;
				Op[i + 2][key2] = 13;
				for (int k = i - 1; k < i + 2; k++)
				{
					for (int p = key2 - 1; p < key2 + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = i; k < i + 3; k++)
				{
					for (int p = key2 - 1; p < key2 + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = i+1; k < i + 4; k++)
				{
					for (int p = key2 - 1; p < key2 + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				t = true;
				return t;
			}
		}
		break;
	case 4:
		for (int i = 0; i < 7; i++)
		{
			if (Op[key][i] == 9 && Op[key][i + 1] == 9 && Op[key][i + 2] == 9 && Op[key][i + 3] == 9)
			{
				Op[key][i] = 13;
				Op[key][i + 1] = 13;
				Op[key][i + 2] = 13;
				Op[key][i + 3] = 13;
				for (int k = key - 1; k < key + 2; k++)
				{
					for (int p = i - 1; p < i + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = key - 1; k < key + 2; k++)
				{
					for (int p = i; p < i + 3; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = key - 1; k < key + 2; k++)
				{
					for (int p = i + 1; p < i + 4; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = key - 1; k < key + 2; k++)
				{
					for (int p = i + 2; p < i + 5; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				t = true;
				return t;
			}
		}
		for (int i = 0; i < 7; i++)
		{
			if (Op[i][key2] == 9 && Op[i + 1][key2] == 9 && Op[i + 2][key2] == 9 && Op[i + 3][key2] == 9)
			{
				Op[i][key2] = 13;
				Op[i + 1][key2] = 13;
				Op[i + 2][key2] = 13;
				Op[i + 3][key2] = 13;
				for (int k = i - 1; k < i + 2; k++)
				{
					for (int p = key2 - 1; p < key2 + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = i; k < i + 3; k++)
				{
					for (int p = key2 - 1; p < key2 + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = i + 1; k < i + 4; k++)
				{
					for (int p = key2 - 1; p < key2 + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				for (int k = i + 2; k < i + 5; k++)
				{
					for (int p = key2 - 1; p < key2 + 2; p++)
					{
						if (k >= 0 && p >= 0 && k < 10 && p < 10)
						{
							if (Op[k][p] != 13)
								Op[k][p] = 5;
						}
					}
				}
				t = true;
				return t;
			}
		}
		break;
	}
	return t;
}
bool Check_win(int**Op)
{
	bool t = false;
	int tmp = 0;
	for (int i = 0; i < 10; i++)
	{
		for (int j = 0; j < 10; j++)
		{
			if (Op[i][j] == 13)
				tmp++;
		}
	}
	if (tmp == 20)
		t = true;
	return t;
}
void Op_shot(int** My)
{
	for (;;)
	{
		int a1 = 0;
		int&a = a1;
		a = rand() % 10;
		int b1 = 0;
		int&b = b1;
		b = rand() % 10;
		if (My[a][b] == 0)
		{
			cout << "\nComputer miss:)\n";
			My[a][b] = 5;
			break;
		}
		else if (My[a][b] == 1)
		{
			cout << "\nComputer kills!\n";
			My[a][b] = 13;
			for (int i = a- 1; i < a+ 2; i++)
			{
				for (int j = b- 1; j < b + 2; j++)
				{
					if (i >= 0 && j >= 0 && i < 10 && j < 10)
					{
						if (My[i][j] != 13)
							My[i][j] = 5;
					}
				}
			}
			break;
		}
		else if (My[a][b] == 2)
		{
			My[a][b] = 7;
			bool t = Check_kill(My, a, b, 2);
			if (t)
				cout << "\nComputer kills!\n";
			else
			{
				cout << "\nComputer hits!\n";
			}
			break;
		}
		else if (My[a][b] == 3)
		{
			My[a][b] = 8;
			bool t = Check_kill(My, a, b, 3);
			if (t)
				cout << "\nComputer kills!\n";
			else
				cout << "\nComputer hits!\n";
			break;
		}
		else if (My[a][b] == 4)
		{
			My[a][b] = 9;
			bool t = Check_kill(My, a, b, 4);
			if (t)
				cout << "\nComputer kills!\n";
			else
				cout << "\nComputer hits!\n";
			break;
		}
	}
	system("pause");
}
void Saving(int**My, int**Op,FILE*f,int &difficult)
{
	for (int i = 0; i < 10; i++)
	{
		for (int j = 0; j < 10; j++)
		{
			char tt[50];
			_itoa(My[i][j], tt, 10);
			fputs(tt, f);
			fputs(" ", f);
		}
		fputs("\n", f);
	}
	for (int i = 0; i < 10; i++)
	{
		for (int j = 0; j < 10; j++)
		{
			char tt[50];
			_itoa(Op[i][j], tt, 10);
			fputs(tt, f);
			fputs(" ", f);
		}
		fputs("\n", f);
	}
	char tt[50];
	_itoa(difficult, tt, 10);
	fputs(tt, f);
	fputs(" ", f);
}
void Upload(int**My, int**Op, FILE*f, int& difficult)
{
	char buf[50];
		for (int i = 0; i < 10; i++)
		{
			fgets(buf, 50, f);
			char*b = strtok(buf, " ");
			for (int j = 0; j < 10; j++)
			{
				My[i][j] = atoi(b);
					b = strtok(NULL, " \n");
			}
		}
		for (int i = 0; i < 10; i++)
		{
			fgets(buf, 50, f);
			char*b = strtok(buf, " ");
			for (int j = 0; j < 10; j++)
			{
				Op[i][j] = atoi(b);
				b = strtok(NULL, " ");
			}
		}
		fgets(buf, 50, f);
		char*b = strtok(buf, " ");
		difficult = atoi(b);
}
void Self_create(int**My)
{
	int code = 0;
	int keys = 0, keys2 = 0;
	int ship = 4;
	char field[25] = { "  A.B.C.D.E.F.G.H.I.J" };
	bool side = true;
	for (; code != 13;)
	{
		system("cls");
		cout << "\n" << field << "\n";
		if (side)
		{
			if (keys2 > 6)
			{
				if (keys2 == 7)keys2--;
				if (keys2 == 8)keys2 -= 2;
				if (keys2 == 9)keys2 -= 3;
			}
			for (int i = 0; i < 10; i++)
			{
				cout << i + 1;
				if (i < 9)
					cout << " ";
				for (int j = 0; j < 10; j++)
				{
					if (i == keys&&j == keys2)
					{
						cout << "#|";
						continue;
					}
					if (i == keys&&j == keys2 + 1)
					{
						cout << "#|";
						continue;
					}
					if (i == keys&&j == keys2 + 2)
					{
						cout << "#|";
						continue;
					}
					if (i == keys&&j == keys2 + 3)
					{
						cout << "#|";
						continue;
					}
					cout << "_|";
				}
				cout << endl;
			}
		}
		if (!side)
		{

			if (keys > 6)
			{
				if (keys == 7)keys--;
				if (keys == 8)keys -= 2;
				if (keys == 9)keys -= 3;
			}
			for (int i = 0; i < 10; i++)
			{
				cout << i + 1;
				if (i < 9)
					cout << " ";
				for (int j = 0; j < 10; j++)
				{
					if (i == keys&&j == keys2)
					{
						cout << "#|";
						continue;
					}
					if (i == keys + 1 && j == keys2)
					{
						cout << "#|";
						continue;
					}
					if (i == keys + 2 && j == keys2)
					{
						cout << "#|";
						continue;
					}
					if (i == keys + 3 && j == keys2)
					{
						cout << "#|";
						continue;
					}
					cout << "_|";
				}
				cout << endl;
			}
		}
		code = _getch();
		if (code == 13)
			break;
		if (code == 32)
		{
			if (side)
			{
				side = false;
				continue;
			}
			else
			{
				side = true;
				continue;
			}
		}
		code = _getch();
		if (!side)
		{
			if ((code == 80) && (keys < 6))
				keys++;
			if ((code == 72) && (keys > 0))
				keys--;
			if ((code == 77) && (keys2 < 9))
				keys2++;
			if ((code == 75) && (keys2 > 0))
				keys2--;
		}
		else
		{
			if ((code == 80) && (keys < 9))
				keys++;
			if ((code == 72) && (keys > 0))
				keys--;
			if ((code == 77) && (keys2 < 6))
				keys2++;
			if ((code == 75) && (keys2 > 0))
				keys2--;
		}

	}
	if (side)
	{
		for (int i = keys2; i < keys2 + 4; i++)
			My[keys][i] = 4;
	}
	else
		for (int i = keys; i < keys + 4; i++)
			My[i][keys2] = 4;
	for (int count = 0; count < 2; count++)
	{
		bool fail = false;
		code = 0;
		for (; code != 13;)//333333333333333333333333333
		{
			system("cls");
			cout << field << "\n";
			if (side)
			{
				if (keys2 > 7)
				{
					if (keys2 == 8)keys2--;
					if (keys2 == 9)keys2 -= 2;
				}
				for (int i = 0; i < 10; i++)
				{
					cout << i + 1;
					if (i < 9)
						cout << " ";
					for (int j = 0; j < 10; j++)
					{
						if (i == keys&&j == keys2)
						{
							cout << "#|";
							continue;
						}
						if (i == keys&&j == keys2 + 1)
						{
							cout << "#|";
							continue;
						}
						if (i == keys&&j == keys2 + 2)
						{
							cout << "#|";
							continue;
						}
						if (My[i][j] == 4 || My[i][j] == 3)
						{
							cout << "#|";
							continue;
						}
						cout << "_|";
					}
					cout << endl;
				}
			}
			if (!side)
			{
				if (keys > 7)
				{
					if (keys == 8)keys--;
					if (keys == 9)keys -= 2;
				}
				for (int i = 0; i < 10; i++)
				{
					cout << i + 1;
					if (i < 9)
						cout << " ";
					for (int j = 0; j < 10; j++)
					{
						if (i == keys&&j == keys2)
						{
							cout << "#|";
							continue;
						}
						if (i == keys + 1 && j == keys2)
						{
							cout << "#|";
							continue;
						}
						if (i == keys + 2 && j == keys2)
						{
							cout << "#|";
							continue;
						}
						if (My[i][j] == 4 || My[i][j] == 3)
						{
							cout << "#|";
							continue;
						}
						cout << "_|";
					}
					cout << endl;
				}
			}
			code = _getch();
			if (code == 13)
				break;
			if (code == 32)
			{
				if (side)
				{
					side = false;
					continue;
				}
				else
				{
					side = true;
					continue;
				}
			}
			code = _getch();
			if (!side)
			{
				if ((code == 80) && (keys < 7))
					keys++;
				if ((code == 72) && (keys > 0))
					keys--;
				if ((code == 77) && (keys2 < 9))
					keys2++;
				if ((code == 75) && (keys2 > 0))
					keys2--;
			}
			else
			{
				if ((code == 80) && (keys < 9))
					keys++;
				if ((code == 72) && (keys > 0))
					keys--;
				if ((code == 77) && (keys2 < 7))
					keys2++;
				if ((code == 75) && (keys2 > 0))
					keys2--;
			}
		}
		if (side)
		{
			for (int i = keys - 1; i < keys + 2; i++)
			{
				for (int j = keys2 - 1; j < keys2 + 2; j++)
				{
					if (i >= 0 && j >= 0 && i < 10 && j < 10)
					{
						if (My[i][j] == 4 || My[i][j] == 3)
						{
							cout << "\You can't place it here. Try again\n";
							system("pause");
							count--;
							fail = true;
							break;
						}
					}
				}
				if (fail)break;
			}
			if (fail)continue;
			for (int i = keys2; i < keys2 + 3; i++)
				My[keys][i] = 3;
		}
		else
		{
			for (int i = keys - 1; i < keys + 2; i++)
			{
				for (int j = keys2 - 1; j < keys2 + 2; j++)
				{
					if (i >= 0 && j >= 0 && i < 10 && j < 10)
					{
						if (My[i][j] == 4 || My[i][j] == 3)
						{
							cout << "\You can't place it here. Try again\n";
							system("pause");
							count--;
							fail = true;
							break;
						}
					}
				}
				if (fail)break;
			}
			if (fail)continue;
			for (int i = keys; i < keys + 3; i++)
				My[i][keys2] = 3;
		}
	}
	for (int count = 0; count < 3; count++)
	{
		bool fail = false;
		code = 0;
		for (; code != 13;)//22222222222222222222222222
		{
			system("cls");
			cout << field << "\n";
			if (side)
			{
				if (keys2 > 8)
				{
					if (keys2 == 9)keys2 --;
				}
				for (int i = 0; i < 10; i++)
				{
					cout << i + 1;
					if (i < 9)
						cout << " ";
					for (int j = 0; j < 10; j++)
					{
						if (i == keys&&j == keys2)
						{
							cout << "#|";
							continue;
						}
						if (i == keys&&j == keys2 + 1)
						{
							cout << "#|";
							continue;
						}
						if (My[i][j] == 4 || My[i][j] == 3 || My[i][j] == 2)
						{
							cout << "#|";
							continue;
						}
						cout << "_|";
					}
					cout << endl;
				}
			}
			if (!side)
			{
				if (keys > 8)
				{
					if (keys == 9)keys--;
				}
				for (int i = 0; i < 10; i++)
				{
					cout << i + 1;
					if (i < 9)
						cout << " ";
					for (int j = 0; j < 10; j++)
					{
						if (i == keys&&j == keys2)
						{
							cout << "#|";
							continue;
						}
						if (i == keys + 1 && j == keys2)
						{
							cout << "#|";
							continue;
						}
						if (My[i][j] == 4 || My[i][j] == 3 || My[i][j] == 2)
						{
							cout << "#|";
							continue;
						}
						cout << "_|";
					}
					cout << endl;
				}
			}
			code = _getch();
			if (code == 13)
				break;
			if (code == 32)
			{
				if (side)
				{
					side = false;
					continue;
				}
				else
				{
					side = true;
					continue;
				}
			}
			code = _getch();
			if (!side)
			{
				if ((code == 80) && (keys < 8))
					keys++;
				if ((code == 72) && (keys > 0))
					keys--;
				if ((code == 77) && (keys2 < 9))
					keys2++;
				if ((code == 75) && (keys2 > 0))
					keys2--;
			}
			else
			{
				if ((code == 80) && (keys < 9))
					keys++;
				if ((code == 72) && (keys > 0))
					keys--;
				if ((code == 77) && (keys2 < 8))
					keys2++;
				if ((code == 75) && (keys2 > 0))
					keys2--;
			}
		}
		if (side)
		{
			for (int i = keys - 1; i < keys + 2; i++)
			{
				for (int j = keys2 - 1; j < keys2 + 2; j++)
				{
					if (i >= 0 && j >= 0 && i < 10 && j < 10)
					{
						if (My[i][j] == 4 || My[i][j] == 3 || My[i][j] == 2)
						{
							cout << "\You can't place it here. Try again\n";
							system("pause");
							count--;
							fail = true;
							break;
						}
					}
				}
				if (fail)break;
			}
			if (fail)continue;
			for (int i = keys2; i < keys2 + 2; i++)
				My[keys][i] = 2;
		}
		else
		{
			for (int i = keys - 1; i < keys + 2; i++)
			{
				for (int j = keys2 - 1; j < keys2 + 2; j++)
				{
					if (i >= 0 && j >= 0 && i < 10 && j < 10)
					{
						if (My[i][j] == 4 || My[i][j] == 3 || My[i][j] == 2)
						{
							cout << "\You can't place it here. Try again\n";
							system("pause");
							count--;
							fail = true;
							break;
						}
					}
				}
				if (fail)break;
			}
			if (fail)continue;
			for (int i = keys; i < keys + 2; i++)
				My[i][keys2] = 2;
		}
	}
	for (int count = 0; count < 4; count++)
	{
		bool fail = false;
		code = 0;
		for (; code != 13;)//11111111111111111111111
		{
			system("cls");
			cout << field << "\n";

			for (int i = 0; i < 10; i++)
			{
				cout << i + 1;
				if (i < 9)
					cout << " ";
				for (int j = 0; j < 10; j++)
				{
					if (i == keys&&j == keys2)
					{
						cout << "#|";
						continue;
					}
					if (My[i][j] == 4 || My[i][j] == 3 || My[i][j] == 2 || My[i][j] == 1)
					{
						cout << "#|";
						continue;
					}
					cout << "_|";
				}
				cout << endl;
			}

			code = _getch();
			if (code == 13)
				break;
			code = _getch();
			if (!side)
			{
				if ((code == 80) && (keys < 9))
					keys++;
				if ((code == 72) && (keys > 0))
					keys--;
				if ((code == 77) && (keys2 < 9))
					keys2++;
				if ((code == 75) && (keys2 > 0))
					keys2--;
			}
			else
			{
				if ((code == 80) && (keys < 9))
					keys++;
				if ((code == 72) && (keys > 0))
					keys--;
				if ((code == 77) && (keys2 < 9))
					keys2++;
				if ((code == 75) && (keys2 > 0))
					keys2--;
			}
		}


		for (int i = keys - 1; i < keys + 2; i++)
		{
			for (int j = keys2 - 1; j < keys2 + 2; j++)
			{
				if (i >= 0 && j >= 0 && i < 10 && j < 10)
				{
					if (My[i][j] == 4 || My[i][j] == 3 || My[i][j] == 2 || My[i][j] == 1)
					{
						cout << "\You can't place it here. Try again\n";
						system("pause");
						count--;
						fail = true;
						break;
					}
				}
			}
			if (fail)break;
		}
		if (fail)continue;
		for (int i = keys; i < keys + 1; i++)
			My[i][keys2] = 1;
	}
}
int Choose_difficult()
{
	int key = 0;
	int code = 0;
	for (; code != 13;)
	{
		system("cls");
		if (key  == 0)
			cout << ">Easy\t<\n";
		else
			cout << "Easy\n";
		if (key == 1)
			cout << ">Medium\t<\n";
		else
			cout << "Medium\n";
		if (key == 2)
			cout << ">Hard\t<\n";
		else
			cout << "Hard\n";
		code = _getch();
		if (code == 13)
			break;
		code = _getch();
		if (code == 80&&key<2)
			key++;
		if (code == 72&&key>0)
			key--;
	}
	return key;
}
void Medium_shot(int**My,int&medium_a,int&medium_b,bool&medium_mem)
{
	for (;;)
	{
		int a1 = 0;
		int&a = a1;
		int b1 = 0;
		int&b = b1;
		if (!medium_mem)
		{
			a = rand() % 10;
		    b = rand() % 10;
		}
		else 
		{
			a = medium_a;
			b = medium_b;
		}
		if (My[a][b] == 0)
		{
			cout << "\nComputer miss:)\n";
			My[a][b] = 5;
			break;
		}
		else if (My[a][b] == 1)
		{
			cout << "\nComputer kills!\n";
			My[a][b] = 13;
			for (int i = a - 1; i < a + 2; i++)
			{
				for (int j = b - 1; j < b + 2; j++)
				{
					if (i >= 0 && j >= 0 && i < 10 && j < 10)
					{
						if (My[i][j] != 13)
							My[i][j] = 5;
					}
				}
			}
			break;
		}
		else if (My[a][b] == 2)
		{
			My[a][b] = 7;
			bool t = Check_kill(My, a, b, 2);
			if (t)
			{
				medium_mem = false;
				cout << "\nComputer kills!\n";
			}
			else
			{
				medium_mem = true;
				for (int i = a - 1; i < a + 2; i++)
				{
					for (int j = b - 1; j < b + 2; j++)
						if (i >= 0 && j >= 0 && i < 10 && j < 10)
						{
							if (My[i][j] == 2)
							{
								medium_a = i;
								medium_b = j;
								break;
							}
						}
				}
				cout << "\nComputer hits!\n";
			}
			break;
		}
		else if (My[a][b] == 3)
		{
			My[a][b] = 8;
			bool t = Check_kill(My, a, b, 3);
			if (t)
			{
				medium_mem = false;
				cout << "\nComputer kills!\n";
			}
			else
			{
				medium_mem = true;
				for (int i = a - 1; i < a + 2; i++)
				{
					for (int j = b - 1; j < b + 2; j++)
						if (i >= 0 && j >= 0 && i < 10 && j < 10)
						{
							if (My[i][j] == 3)
							{
								medium_a = i;
								medium_b = j;
								break;
							}
						}
				}
				cout << "\nComputer hits!\n";
			}
			break;
		}
		else if (My[a][b] == 4)
		{
			My[a][b] = 9;
			bool t = Check_kill(My, a, b, 4);
			if (t)
			{
				medium_mem = false;
				cout << "\nComputer kills!\n";
			}
			else
			{
				medium_mem = true;
				for (int i = a - 1; i < a + 2; i++)
				{
					for (int j = b - 1; j < b + 2; j++)
						if (i >= 0 && j >= 0 && i < 10 && j < 10)
						{
							if (My[i][j] == 4)
							{
								medium_a = i;
								medium_b = j;
								break;
							}
						}
				}
				cout << "\nComputer hits!\n";
			}
			break;
		}
		else 
			medium_mem = false;
	}
	system("pause");
}
void Hard_shot(int**My)
{
	for (;;)
	{
		int a = 0, b = 0;
		for (int i = 0; i < 10; i++)
		{
			bool t = false;
			for (int j = 0; j < 10; j++)
			{
				if (My[i][j] == 1 || My[i][j] == 2 || My[i][j] == 3 || My[i][j] == 4)
				{
					a = i;
					b = j;
					t = true;
					break;
				}
			}
			if (t)
				break;
		}
		if (My[a][b] == 0)
		{
			cout << "\nComputer miss:)\n";
			My[a][b] = 5;
			break;
		}
		else if (My[a][b] == 1)
		{
			cout << "\nComputer kills!\n";
			My[a][b] = 13;
			for (int i = a - 1; i < a + 2; i++)
			{
				for (int j = b - 1; j < b + 2; j++)
				{
					if (i >= 0 && j >= 0 && i < 10 && j < 10)
					{
						if (My[i][j] != 13)
							My[i][j] = 5;
					}
				}
			}
			break;
		}
		else if (My[a][b] == 2)
		{
			My[a][b] = 7;
			bool t = Check_kill(My, a, b, 2);
			if (t)
				cout << "\nComputer kills!\n";
			else
			{
				cout << "\nComputer hits!\n";
			}
			break;
		}
		else if (My[a][b] == 3)
		{
			My[a][b] = 8;
			bool t = Check_kill(My, a, b, 3);
			if (t)
				cout << "\nComputer kills!\n";
			else
				cout << "\nComputer hits!\n";
			break;
		}
		else if (My[a][b] == 4)
		{
			My[a][b] = 9;
			bool t = Check_kill(My, a, b, 4);
			if (t)
				cout << "\nComputer kills!\n";
			else
				cout << "\nComputer hits!\n";
			break;
		}
	}
	system("pause");
}