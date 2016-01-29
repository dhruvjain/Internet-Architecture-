#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#define MAXBUFLEN 100

int main()
{
	int sockfd;
	int MYPORT;
	printf("Enter port\n");
	scanf("%d",&MYPORT);
	struct sockaddr_in my_addr;    // my address information
	struct sockaddr_in their_addr; // connector’s address information
	int addr_len, numbytes;
	char buf[MAXBUFLEN];

	if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
		perror("socket");
		exit(1);
	}
	my_addr.sin_family = AF_INET;         // host byte order
	my_addr.sin_port = htons(MYPORT);     // short, network byte order
	my_addr.sin_addr.s_addr = INADDR_ANY; // automatically fill with my IP
	memset(&(my_addr.sin_zero), '\0', 8); // zero the rest of the struct

	if (bind(sockfd, (struct sockaddr *)&my_addr,sizeof(struct sockaddr)) == -1) {
		perror("bind");
		exit(1);
	}

	addr_len = sizeof(struct sockaddr);
	while(1){
		if ((numbytes=recvfrom(sockfd,buf, MAXBUFLEN-1, 0,(struct sockaddr *)&their_addr, &addr_len)) == -1) {
			perror("recvfrom");
			exit(1);
		}

		printf("got packet from %s\n",inet_ntoa(their_addr.sin_addr));
		printf("packet is %d bytes long\n",numbytes);
		buf[numbytes] = '\0';
		printf("packet contains \"%s\"\n",buf);
		printf("\n\n");
		memset(&(their_addr.sin_zero), '\0', 8); // zero the rest of the struct
		char mssg[]="hello";
		if ((numbytes=sendto(sockfd, mssg, strlen(mssg), 0,(struct sockaddr *)&their_addr, sizeof(struct sockaddr))) == -1) {
			perror("sendto");
			exit(1);
		}
		printf("sent %d bytes to %s\n", numbytes,inet_ntoa(their_addr.sin_addr));
	}
	close(sockfd);
	return 0;
}