#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* trimWhitespace(char* str) {
    while (*str == ' ' || *str == '\t' || *str == '\n' || *str == '\r') {
        str++;
    }
    int len = strlen(str);
    while (len > 0 && (str[len - 1] == ' ' || str[len - 1] == '\t' || str[len - 1] == '\n' || str[len - 1] == '\r')) {
        len--;
    }
    str[len] = '\0';
    return str;
}

int main() {
    FILE *file = fopen("day4.in", "r");
    if (file == NULL) {
        perror("Error opening file");
        return 1;
    }

    int sum = 0;

    char line[256];
    while (fgets(line, sizeof(line), file)) {
        // Remove the first 10 characters
        memmove(line, line + 10, strlen(line) - 10 + 1);

        // Split the string by '|'
        char *winnerNumberValuesString = strtok(line, "|");
        char *allNumberValuesString = strtok(NULL, "|");

        // Trim whitespaces
        winnerNumberValuesString = trimWhitespace(winnerNumberValuesString);
        allNumberValuesString = trimWhitespace(allNumberValuesString);

        // Convert the substrings to int arrays
        int winnerNumberValues[25]; // Adjust the size as needed
        int allNumberValues[25];    // Adjust the size as needed

        int i = 0;
        char *token = strtok(winnerNumberValuesString, " ");
        while (token != NULL) {
            winnerNumberValues[i++] = atoi(token);
            token = strtok(NULL, " ");
        }

        i = 0;
        token = strtok(allNumberValuesString, " ");
        while (token != NULL) {
            allNumberValues[i++] = atoi(token);
            token = strtok(NULL, " ");
        }

        // Now you have the two integer arrays, winnerNumberValues and allNumberValues
        // Do whatever you need with them here

        int counter = 0;

        for (int k = 0; k < i; k++) {
            for (int j = 0; j < i; j++) {
                if (allNumberValues[j] == winnerNumberValues[k]) {

                    if (counter == 0) {
                        counter++;
                    } 
                    else {
                        counter *= 2;
                    }
                    
                    break;
                }
            }
        }

        sum += counter;
    }

    fclose(file);

    printf("Result: %d", sum);

    return 0;
}