#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

#define BUF_SIZE 256
#define MAX_NUMBER 100
#define MAX_CARDS 250

int main()
{
    FILE *file = fopen("day4.in", "rt");
    if (file == NULL) {
        perror("Error opening file");
        return 1;
    }

    uint64_t solution_p1 = 0;
    char line[BUF_SIZE] = {0};
    bool numbers[MAX_NUMBER] = {0};
    uint64_t solution_p2 = 0;
    uint64_t num_count[MAX_CARDS] = {0};
    uint64_t card_count[MAX_CARDS] = {0};

    while (fgets(line, sizeof(line), file))
    {
        char *game = strtok(line, ":");
        char *card = strtok(NULL, "|");
        char *win  = strtok(NULL, "\n");
        char *game_end = game;
        size_t card_id = strtoll(game+5, &game_end, 10);
        char *card_start = card;
        char *card_end = card;
        while (*card_end != '\0')
        {
            size_t n = strtoll(card_start, &card_end, 10);
            
            if (card_end != card_start)
            {
                numbers[n] = true;
                card_start = card_end;
            }
            else
            {
                break;
            }
        }
        uint64_t win_count = 0;
        char *win_start = win;
        char *win_end = win;
        while (*win_end != '\0')
        {
            size_t n = strtoll(win_start, &win_end, 10);
            if (win_end != win_start)
            {
                if (numbers[n]) win_count++;
                win_start = win_end;
            }
            else
            {
                break;
            }
        }
        if (win_count > 0)
        {
            solution_p1 += 1 << (win_count - 1);
        }

        num_count[card_id] = win_count;
        card_count[card_id] += 1;
        memset(numbers, 0, sizeof(numbers));
    }
    
    fclose(file);

    for (size_t i = 0; i < MAX_CARDS; i++)
    {
        for (size_t j = i+1; j <= i + num_count[i]; j++)
        {
            card_count[j] += card_count[i];
        }
    }

    for (size_t i = 0; i < MAX_CARDS; i++)
    {
        solution_p2 += card_count[i];
    }

    printf("Result: %d\n", solution_p2);

    return 0;
}